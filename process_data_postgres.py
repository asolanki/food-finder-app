from config import CALENDAR_ID, GOOGLE_API_KEY, PARSE_APP_ID, PARSE_REST_KEY
from config import METERS_PER_MILE, CENTRAL_COORDINATES, LOGGING_DIR, POSTGRES
from config import REDIS_FIELDS

from location_backup import location_fixes

import json
import psycopg2
import logging
import httplib
import datetime
import urllib2
import urllib
import unicodedata

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

#Dump a food event into the database
def dump_event(db_con, food_event):
    cur = db_con.cursor()
    values = (\
        food_event['event_id'],
        food_event['name'],
        food_event['location'],
        food_event['description'],
        food_event['coordinates'],
        food_event['start_time'],
        food_event['end_time'],
        food_event['most_recent_time']
    )
    values_string = '('
    for x in range(len(values)):
        values_string += '%s, '
    values_string = values_string[:-2] + ')'
    cur.execute(
        """INSERT INTO {0} VALUES {1};"""\
        .format(POSTGRES['tbl_fe'],values_string),
        values)
    db_con.commit()
    cur.close()

def get_food_event(one_event):
    return {
    	'event_id' : one_event[u'id'],
    	'start_time' : one_event[u'start'][u'dateTime'],
    	'end_time' : one_event[u'end'][u'dateTime'],
    	'location' : one_event[u'location'],
    	'name' : one_event[u'summary'],
    	'description' : one_event[u'description'],
    	'most_recent_time' : one_event[u'updated'],
        'coordinates' : 'abcdefg'
    }

#Make a generic API call using a given URL (used for Google Calendar request).
#It expects json to be returned, and thus returns a dictionary based on the json
#returned from the API call.
# @param url The API URL call as a string
# @return A dictionary containing the returned json from the API URL call, or a
# dictionary containing an "ERROR" entry for an error (and the URL)
def api_req(url):
    #api_logger.info(url)
    request = urllib2.Request(url)
    try:
        response = urllib2.urlopen(request)
        return json.loads(response.read())
    except e:
        return { 'ERROR' : e, 'API_CALL' : url }

def main():
    db_con = psycopg2.connect("dbname={0} user={1} password={2}".format(\
                              POSTGRES['dbname'],
                              POSTGRES['user'],
                              POSTGRES['password']))

    events_to_push = []
    events_list_dict = api_req(GET_EVENTS)

    #Did we hit an error on the Google Calendar call? If so, log it and exit.
    if 'ERROR' in events_list_dict:
    #    general_logger.error('Error getting google calendar info (check'\
    #                         ' api log)')
        exit (1)

    #List of event ids in the google calendar - makes it easier to detect
    #deletes
    cal_ids = []
    test_e = get_food_event(events_list_dict['items'][0])
    dump_event(db_con, test_e)
    db_con.close()

main()


