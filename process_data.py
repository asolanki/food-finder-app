# process_data.py
# Simple script to grab event data from a google calendar, store it in a locally
# running Redis database, and push the data up to the Parse cloud.

from config import CALENDAR_ID, GOOGLE_API_KEY, PARSE_APP_ID, PARSE_REST_KEY
from config import METERS_PER_MILE, CENTRAL_COORDINATES, LOGGING_DIR, REDIS

import json
import redis
import logging
import httplib
import datetime
import urllib2
import urllib

#Logging mechanisms
log_format = logging.Formatter('%(asctime)s -- %(levelname)s -- %(message)s')

redis_logger = logging.getLogger('redis')
redis_handler = logging.FileHandler('logs/redis.log')
redis_handler.setFormatter(log_format)
redis_logger.addHandler(redis_handler)

parse_logger = logging.getLogger('parse')
parse_handler = logging.FileHandler('logs/parse.log')
parse_handler.setFormatter(log_format)
parse_logger.addHandler(parse_handler)

stdio_logger = logging.getLogger('stdio')
stdio_handler = logging.FileHandler('logs/stdio.log')
stdio_handler.setFormatter(log_format)
stdio_logger.addHandler(stdio_handler)

#String constant for google calendar API request, based on API key and Calendar
#ID
GET_EVENTS='https://www.googleapis.com/calendar/v3/'\
    'calendars/{cid}/events/?key={key}'\
    '&singleEvents=true&orderBy=starttime'\
    .format(cid=CALENDAR_ID,key=GOOGLE_API_KEY)

#String constant for google maps API request, based on 
GET_LOCATION = 'https://maps.googleapis.com/maps/api/place/textsearch/'\
    'json?sensor=false&key={api}&location={location}&radius={radius}'.format(\
                    api=GOOGLE_API_KEY,\
                    location=CENTRAL_COORDINATES,\
                    radius=METERS_PER_MILE * 4)

# handles query to google maps API
# @param loc_in the query string
# @return dictionary holding 'latitude' and 'longitude'
def handleLocation(loc_in):
    loc_in = urllib.quote(loc_in)
    maps_req = GET_LOCATION + '&query={0}'.format(loc_in)

    request = urllib2.Request(maps_req)
    location_dict = {}

    try:
        response = urllib2.urlopen(request)
        location_dict = json.loads(response.read())['results'][0][u'geometry']\
                                                                 [u'location']
    except urllib2.HTTPError, e:
        print e
        exit(1)

    return_dict = {}
    return_dict['latitude'] = location_dict[u'lat']
    return_dict['longitude'] = location_dict[u'lng']
    return return_dict

# Given an event (as a dict) from a Google calendar, return a food_event dict.
# @param one_event Single food event, as represented from the Google Cal API
# @return food_event dict, containing the information needed for our apps
def get_food_event(one_event):
    id_str = one_event[u'id']
    food_event = {
    	'event_id' : id_str,
    	'start_time' : one_event[u'start'][u'dateTime'],
    	'end_time' : one_event[u'end'][u'dateTime'],
    	'location' : one_event[u'location'],
    	'name' : one_event[u'summary'],
    	'description' : one_event[u'description'],
    	'most_recent_time' : one_event[u'updated']
    }
    coords = handleLocation(food_event['location'])
    food_event['latitude'] = coords['latitude']
    food_event['longitude'] = coords['longitude']
    return food_event

#Given a food_event dict and a redis db instance, dump the fields in the
#food_event dict into redis using <EVENT_ID>-<ATTR_NAME> format
# @param redis_db A local redis database instance.
# @param food_event A formatted food_event dictionary
def update_redis(redis_db, food_event):
    for food_event_attr in food_event.keys():
        if food_event_attr != 'event_id':
            redis_db.set(food_event['event_id']+'-'+food_event_attr,\
                    food_event[food_event_attr])

#Make a request to the Parse cloud. Default is a POST, but could also be a PUT
#(for updating)
# @param food_obj A formatted food_event dictionary
# @param req The type of Parse request to make. Default is POST.
def parse_req(food_obj, req='POST'):
    connection = httplib.HTTPSConnection('api.parse.com', 443)
    connection.connect()
    connection.request(req, '/1/classes/FoodObject', json.dumps(food_obj),\
                       {                        
                           "X-Parse-Application-Id": PARSE_APP_ID,
                           "X-Parse-REST-API-Key": PARSE_REST_KEY,
                           "Content-Type": "application/json"
                       })
    result = json.loads(connection.getresponse().read())
    return result


#Make a generic API call using a given URL (used for Google Calendar request).
#It expects json to be returned, and thus returns a dictionary based on the json
#returned from the API call.
# @param url The API URL call as a string
# @return A dictionary containing the returned json from the API URL call, or a
# dictionary containing a single "ERROR" entry for an error
def api_req(url):
    request = urllib2.Request(url)

    try:
        response = urllib2.urlopen(request)
        return json.loads(response.read())
    except urllib2.HTTPError, e:
        print e
        return { "ERROR" : e }

#Main script. Job is to retrieve data from google calendar, extract relevant
#fields, save the data in the local redis instance currently running, and push
#the data up to the Parse cloud. Should be able to handle both new events and
#updated/changed events (based on what is already saved in the local redis DB)
def main():
    redis_logger.info('Opening redis db at {0} on port {1} at database {2}')\
                     .format(REDIS['host'],REDIS['port'],REDIS['db'])
    try: 
        redis_db = redis.StrictRedis(\
            host=REDIS['host'],\
            port=REDIS['port'],\
            db=REDIS['db'])
    except e:
        redis_logger.error('')
    
    redis_logger.info('Successfully opened redis db')
    events_to_push = []
    events_list_dict = api_req(GET_EVENTS)

    #Did we hit an error on the Google Calendar call? If so, log it and exit.
    if events_list_dict['ERROR']:
        print events_list_dict['ERROR']
        exit (1)

    #Main loop for processing events from Google calendar.
    for one_event in events_list_dict['items']:

        #Are we dealing with an update?
        if redis_db.exists(one_event[u'id']):

            id_str = one_event[u'id']

            #Compare the update time to our most recent time to determine if the
            #event has changed.
            our_time = datetime.datetime.\
                strptime(redis_db.get(id_str+'-'+'most_recent_time'),\
                '%Y-%m-%dT%H:%M:%S.%fZ')
            up_time = datetime.datetime.\
                strptime(one_event[u'updated'],\
                '%Y-%m-%dT%H:%M:%S.%fZ')
            delta = up_time - our_time
            zerotime = datetime.timedelta()

            #Only need to process the event if it has been updated.
            if delta != zerotime:
                # Could be slightly more efficient if we only updated location when
                # it actually changes, but this should be fine for now
                food_event = get_food_event(one_event)
                update_redis(redis_db, food_event)
                parse_req(food_event, 'PUT')

        #Dealing with a create (new event)
        else:
            food_event = get_food_event(one_event)
            update_redis(redis_db, food_event)
            reply = parse_req(food_event)
            redis_db.set(food_event['event_id'], reply['objectId'])

    #After all our work is done, save the Redis DB to disk.
    redis_db.save()


#Start it up...
#main() 
