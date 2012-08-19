# config.py
# Configuration file for food finder project.

# The google calendar ID to use.
CALENDAR_ID = 'virginia.edu_vmok4n893trne2cebnb2ui3eic@group.calendar.google.com'

# The google calendar API key.
GOOGLE_API_KEY = 'AIzaSyAdvIBlSWMdn-Ed4c_BmQUI86-GuEFrVl0'

# The application ID for Parse.
PARSE_APP_ID = 'dF4lf8kvjIWL3PqE8ANdS5ancdatrrlYMw0Dm2nM'

# The REST API key for Parse.
PARSE_REST_KEY = '1sRa9Ok1c5UOLKDB8glwq95KEk6mN0EITvAkaDQz'

#Google maps API constant
METERS_PER_MILE = 1699.34

#Limit search results on Google Maps API
#Coordinates for the Rotunda
CENTRAL_COORDINATES = '38.038087,-78.501949'

#Logging directory
LOGGING_DIR = 'logs'

#Redis database info
REDIS = {
    'host': 'localhost',
    'port': 6379,
    'db': 0 
}

#Fields we store for each event in redis
REDIS_FIELDS = [
    'event_id',
    'start_time',
    'end_time',
    'location',
    'name',
    'description',
    'most_recent_time',
    'coordinates'
]
