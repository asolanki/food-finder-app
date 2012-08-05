#scraper.py
#Simple script to scrape event data from a google calendar and convert it into
#Python dictionaries.

from config import CALENDAR_ID
from config import GOOGLE_API_KEY
from config import PARSE_APP_ID
from config import PARSE_REST_KEY
import json
import redis
import httplib
import datetime

#TODO: Think about how best to deal with the API call. Generate current
#datetime, only get events for the current week? Month?
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

events_to_push = []

for one_event in events_list_dict['items']:
    event_to_push = {}
    print "\tID: " + one_event[u'id']
    print "\tTITLE: " + one_event[u'summary']
    if u'location' in one_event:
        print "\tLOC: " + one_event[u'location']
    #TODO: In this loop, for every event, store event data as a dictionary. Add
    #these dictionaries to a list. Then, process this list, pushing each event to
    #Parse and storing a mapping from the event id to the Parse object ID on a
    #local redis database. [Can determine whether or not to push to Parse based
    #on whether the event ID is already stored in redis]
   
