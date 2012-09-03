#Used to correct locations which are assigned incorrect coordinates by the
#google places api. Handy for rebuilding the data/database migrations. Note this
#only includes locations that are not accurate when we attempt to retrieve them
#with google places.

location_fixes = {
    'South Lawn': '38.033304,-78.504633',
    'Madhouse': '38.041222,-78.494645',
    'East K Parking Lot': '38.034411,-78.510019'
}
