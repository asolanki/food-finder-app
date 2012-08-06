#scraper.py
#Simple script to scrape event data from a google calendar and convert it into
#Python dictionaries.

from config import CALENDAR_ID, GOOGLE_API_KEY, PARSE_APP_ID, PARSE_REST_KEY
import mapAdapter

import json
import redis
import httplib
import datetime
import urllib2



#Given an event (as a dict) from a Google calendar, return a food_event dict.
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
    coords = mapAdapter.handleLocation(food_event['location'])
    food_event['latitude'] = coords['latitude']
    food_event['longitude'] = coords['longitude']
    return food_event
    
def update_redis(redis_db, food_event):
    for food_event_attr in food_event.keys():
        if food_event_attr != 'event_id':
            redis_db.set(food_event['event_id']+'-'+food_event_attr,\
                    food_event[food_event_attr])
        else:
            redis_db.set(food_event['event_id'], '')

GET_EVENTS='https://www.googleapis.com/calendar/v3/'\
    'calendars/{cid}/events/?key={key}'\
    '&singleEvents=true&orderBy=starttime'\
    .format(cid=CALENDAR_ID,key=GOOGLE_API_KEY)

request = urllib2.Request(GET_EVENTS)

events_list_dict = {}
try:
    response = urllib2.urlopen(request)
    events_list_dict = json.loads(response.read())
except urllib2.HTTPError, e:
    print e
    exit(1)


redis_db = redis.StrictRedis(host='localhost', port=6379, db=0)
events_to_push = []
for one_event in events_list_dict['items']:
    if redis_db.exists(one_event[u'id']):
        id_str = one_event[u'id']
        our_time = datetime.datetime.\
            strptime(redis_db.get(id_str+'-'+'most_recent_time'),\
            '%Y-%m-%dT%H:%M:%S.%fZ')
        up_time = datetime.datetime.\
            strptime(one_event[u'updated'],\
            '%Y-%m-%dT%H:%M:%S.%fZ')
        delta = up_time - our_time
        zerotime = datetime.timedelta()
        if delta != zerotime:
            #Could be slightly more efficient if we only updated location when
            #it actually changes
            food_event = get_food_event(one_event)
            update_redis(redis_db, food_event)
        #Parse put request

    else:
        #This is a create
        food_event = get_food_event(one_event)
        update_redis(redis_db, food_event)
        #Parse post request
        #Add eventID --> parseID mapping to Redis



