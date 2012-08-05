import urllib2
from config import GOOGLE_API_KEY
import json

METERS_PER_MILE=1699.34
CENTRAL_COORDINATES=38.038087,-78.501949
            # to limit Places API search
            # start as rotunda

# handles query to google maps API
# @param loc_in the query string
# @return dictionary holding 'latitude' and 'longitude'
def handleLocation(loc_in):
    GET_LOCATION = 'https://maps.googleapis.com/maps/api/place/textsearch/'\
        'json?query={query}&sensor=false&key={api}'.format(query=loc_in, \
        api=GOOGLE_API_KEY, location=CENTRAL_COORDINATES, radius=METERS_PER_MILE*4)

    request = urllib2.Request(GET_LOCATION)
    location_dict = {}

    try:
        response = urllib2.urlopen(request)
        location_dict = json.loads(response.read())
    except urllib2.HTTPError, e:
        print e
        exit(1)

    return_dict = {}
    return_dict['latitude'] = location_dict['results'][0][u'geometry'][u'location'][u'lat']
    return_dict['longitude'] = location_dict['results'][0][u'geometry'][u'location'][u'lng']
    return return_dict



