# process_data.py
# Simple script to grab event data from a google calendar, store it in a locally
# running Redis database, and push the data up to the Parse cloud.

from config import CALENDAR_ID, GOOGLE_API_KEY, PARSE_APP_ID, PARSE_REST_KEY
from config import METERS_PER_MILE, CENTRAL_COORDINATES, LOGGING_DIR, REDIS
from config import REDIS_FIELDS

import json
import redis
import logging
import httplib
import datetime
import urllib2
import urllib
import unicodedata

#Logging mechanisms
log_format = logging.Formatter('%(asctime)s -- %(levelname)s -- %(message)s')

root_logger = logging.getLogger('master')
root_handler = logging.FileHandler('{0}/complete.log'.format(LOGGING_DIR))
root_handler.setFormatter(log_format)
root_logger.addHandler(root_handler)
root_logger.setLevel(logging.INFO)

redis_logger = logging.getLogger('master.redis')
redis_handler = logging.FileHandler('{0}/redis.log'.format(LOGGING_DIR))
redis_handler.setFormatter(log_format)
redis_logger.addHandler(redis_handler)
redis_logger.setLevel(logging.INFO)

parse_logger = logging.getLogger('master.parse')
parse_handler = logging.FileHandler('{0}/parse.log'.format(LOGGING_DIR))
parse_handler.setFormatter(log_format)
parse_logger.addHandler(parse_handler)
parse_logger.setLevel(logging.INFO)

general_logger = logging.getLogger('master.general')
general_handler = logging.FileHandler('{0}/general.log'.format(LOGGING_DIR))
general_handler.setFormatter(log_format)
general_logger.addHandler(general_handler)
general_logger.setLevel(logging.INFO)

api_logger = logging.getLogger('master.api')
api_handler = logging.FileHandler('{0}/api.log'.format(LOGGING_DIR))
api_handler.setFormatter(log_format)
api_logger.addHandler(api_handler)
api_logger.setLevel(logging.INFO)

loc_logger = logging.getLogger('location')
loc_handler = logging.FileHandler('{0}/location.log'.format(LOGGING_DIR))
loc_handler.setFormatter(log_format)
loc_logger.addHandler(loc_handler)
loc_logger.setLevel(logging.INFO)

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
def handle_location(redis_db, loc_in):
    
    loc_in = unicodedata.normalize('NFKD', loc_in).encode('ascii','ignore')
    escaped_loc = str.replace(loc_in, ' ', '_')
    redis_loc = 'loc-'+escaped_loc

    #We already have a mapping for this location. Use it!
    if redis_db.exists(redis_loc):
        coords = str.split(redis_db.get(redis_loc), ',')
        return {
            '__type' : 'GeoPoint',
            'latitude' : float(coords[0]),
            'longitude' : float(coords[1]),
        }

    #We don't have a mapping for this location. Guess it from google places, and
    #log this guess so we can check it manually later.
    api_loc = urllib.quote(loc_in)
    maps_req = GET_LOCATION + '&query={0}'.format(api_loc)
    response_dict = api_req(maps_req)

    #The API call went through, but did not return places properly. Default to
    #dummy coords and manually check/enter the location.
    if ('ERROR' in response_dict) or (response_dict['status'] != 'OK'):
        general_logger.warn('Google places API call failed on {0} (check'\
                            ' api log)'.format(loc_in))
        loc_logger.warn('{0} failed'.format(loc_in))
        return {
            '__type' : 'GeoPoint',
            'latitude' : 0.0,
            'longitude' : 0.0,
        }

    #The API call worked. Get the first (most relevant, according to the Places
    #API) location as our "best guess", log it for manual confirmation of
    #correctness later, and return it
    location_dict = response_dict['results'][0][u'geometry'][u'location']

    latitude = location_dict[u'lat']
    longitude = location_dict[u'lng']

    redis_logger.info('Setting new location {0} to {1} (confirm'\
                      ' accuracy)'.format(loc_in,\
                       str(latitude)+','+str(longitude)))
    loc_logger.info('{0} set to {1}'.format(loc_in,\
                       str(latitude)+','+str(longitude)))

    redis_db.set(redis_loc, str(latitude)+','+str(longitude))

    return {
        '__type' : 'GeoPoint',
        'latitude' : latitude,
        'longitude' : longitude,
    }

# Given an event (as a dict) from a Google calendar, return a food_event dict.
# @param one_event Single food event, as represented from the Google Cal API
# @return food_event dict, containing the information needed for our apps
def get_food_event(redis_db, one_event):
    return {
    	'event_id' : one_event[u'id'],
    	'start_time' : one_event[u'start'][u'dateTime'],
    	'end_time' : one_event[u'end'][u'dateTime'],
    	'location' : one_event[u'location'],
    	'name' : one_event[u'summary'],
    	'description' : one_event[u'description'],
    	'most_recent_time' : one_event[u'updated'],
        'coordinates' : handle_location(redis_db, one_event[u'location']),
    }

#Given a food_event dict and a redis db instance, dump the fields in the
#food_event dict into redis using <EVENT_ID>-<ATTR_NAME> format
# @param redis_db A local redis database instance.
# @param food_event A formatted food_event dictionary
def update_redis(redis_db, food_event):
    redis_logger.info('Dumping event {0} into'\
                      ' redis'.format(food_event['event_id']))
#TODO: Add error checking
    for food_event_attr in food_event.keys():
        if food_event_attr != 'event_id':
            redis_db.set(food_event['event_id']+'-'+food_event_attr,\
                    food_event[food_event_attr])

    redis_logger.info('Event successfully dumped to redis.')


#Make a request to the Parse cloud. Default is a POST, but could also be a PUT
#(for updating)
# @param food_obj A formatted food_event dictionary
# @param req The type of Parse request to make. Default is POST.
def parse_req(redis_db, food_obj, req='POST'):
#TODO: Add error checking
    parse_logger.info('Making parse {0} call on event'\
    ' {1}'.format(req,food_obj['event_id']))
    connection = httplib.HTTPSConnection('api.parse.com', 443)
    connection.connect()
    if req=='POST':
        endpoint = '/1/classes/FoodEvent'
    else:
        parseid = redis_db.get(food_obj['event_id'])
        endpoint = '/1/classes/FoodEvent/{0}'.format(parseid)
    connection.request(req, endpoint, json.dumps(food_obj),\
                       {                        
                           "X-Parse-Application-Id": PARSE_APP_ID,
                           "X-Parse-REST-API-Key": PARSE_REST_KEY,
                           "Content-Type": "application/json"
                       })


    result = json.loads(connection.getresponse().read())
    parse_logger.info('Parse {0} call successful'.format(req))
    return result

#Utility function to fix the coordinates of a location. This will:
#1) Update the loc-location_name key in redis.
#2) Update all events with that location in parse to the new (proper) coords.
def fix_coords(redis_db, location, coords):
    escaped_loc = str.replace(location, ' ', '_')
    redis_db.set('loc-'+escaped_loc, coords)
    event_ids = filter(lambda x : '-' not in x, redis_db.keys())
    for event_id in event_ids:
        if redis_db.get(event_id+'-location') == location:
            lat = float(str.split(coords, ',')[0])
            lon = float(str.split(coords, ',')[1])
            parse_dict = {
                'event_id' : event_id,
                'coordinates' : {
                    '__type' : 'GeoPoint',
                    'latitude' : lat,
                    'longitude' : lon,
                },
            }
            parse_req(redis_db, parse_dict, 'PUT')
    redis_db.save()


#Make a generic API call using a given URL (used for Google Calendar request).
#It expects json to be returned, and thus returns a dictionary based on the json
#returned from the API call.
# @param url The API URL call as a string
# @return A dictionary containing the returned json from the API URL call, or a
# dictionary containing an "ERROR" entry for an error (and the URL)
def api_req(url):
    api_logger.info(url)
    request = urllib2.Request(url)
    try:
        response = urllib2.urlopen(request)
        return json.loads(response.read())
    except e:
        return { 'ERROR' : e, 'API_CALL' : url }

#Main script. Job is to retrieve data from google calendar, extract relevant
#fields, save the data in the local redis instance currently running, and push
#the data up to the Parse cloud. Should be able to handle both new events and
#updated/changed events (based on what is already saved in the local redis DB)
def main():
    redis_logger.info('Opening redis db at {0} on port {1} at database {2}'\
                     .format(REDIS['host'],REDIS['port'],REDIS['db']))
    redis_db = redis.StrictRedis(\
            host=REDIS['host'],\
            port=REDIS['port'],\
            db=REDIS['db'])
    try:
        redis_db.ping()
    except redis.exceptions.ConnectionError as err:
        redis_logger.error(str(err))
        exit(1) 

    redis_logger.info('Successfully opened redis db')
    events_to_push = []
    events_list_dict = api_req(GET_EVENTS)

    #Did we hit an error on the Google Calendar call? If so, log it and exit.
    if 'ERROR' in events_list_dict:
        general_logger.error('Error getting google calendar info (check'\
                             ' api log)')
        exit (1)

    #List of event ids in the google calendar - makes it easier to detect
    #deletes
    cal_ids = []

    #Main loop for processing events from Google calendar.
    for one_event in events_list_dict['items']:

        cal_ids.append(one_event[u'id'])

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
                general_logger.info('Updating event {0}'.format(one_event[u'id']))
                food_event = get_food_event(redis_db, one_event)
                update_redis(redis_db, food_event)
                parse_req(redis_db, food_event, 'PUT')
            else:
                general_logger.info('Skipping event {0}, no update needed.'\
                                  .format(one_event[u'id']))

        #Dealing with a create (new event)
        else:
            general_logger.info('Creating event {0}'.format(one_event[u'id']))
            food_event = get_food_event(redis_db, one_event)
            update_redis(redis_db, food_event)
            reply = parse_req(redis_db, food_event)
            redis_db.set(food_event['event_id'], reply['objectId'])


    #First get all event ids saved in the database
    redis_ids = filter(lambda x : '-' not in x, redis_db.keys())

    #If any event ID in redis is no longer in the events from the calendar, we
    #need to delete it from parse (and redis)
    for one_id in redis_ids:
        if one_id not in cal_ids:
            general_logger.info('Deleting event {0}'.format(one_id))
            #We are dealing with a delete. Make the delete call to parse and
            #purge the event data from the redis db.
            parse_req(redis_db, { 'event_id' : one_id }, 'DELETE')

            redis_logger.info('Deleting event {0} from redis'.format(one_id))
            redis_db.delete(one_id)
            for a_field in REDIS_FIELDS:
                redis_db.delete(one_id+'-'+a_field)


    #After all our work is done, save the Redis DB to disk.
    redis_db.save()


#Start it up...
general_logger.info('STARTING PROCESS DATA SCRIPT')
main() 
general_logger.info('ENDING PROCESS DATA SCRIPT')
