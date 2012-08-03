#scraper.py
#Simple script to scrape event data from a google calendar and convert it into
#Python dictionaries.

from config import CALENDAR_ID
from config import API_KEY
import json
import httplib
import urllib2
import datetime

#TODO: Think about how best to deal with the API call. Generate current
#datetime, only get events for the current week? Month?
GET_EVENTS='https://www.googleapis.com/calendar/v3/'\
                'calendars/{cid}/events/?key={key}'\
		'&singleEvents=true&orderBy=starttime'\
		.format(cid=CALENDAR_ID,key=API_KEY)

request = urllib2.Request(GET_EVENTS)

events_list_dict = {}
try:
    response = urllib2.urlopen(request)
    events_list_dict = json.loads(response.read())
except urllib2.HTTPError, e:
    print e
    exit(1)

#TODO: Parse the events dictionary and create a more manageable dictionary for
#easy export to Parse.
