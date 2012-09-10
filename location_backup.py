#Used to correct locations which are assigned incorrect coordinates by the
#google places api. Handy for rebuilding the data/database migrations. Note this
#only includes locations that are not accurate when we attempt to retrieve them
#with google places.

location_fixes = {
    'South Lawn': '38.033304,-78.504633',
    'Madhouse': '38.041222,-78.494645',
    'East K Parking Lot': '38.034411,-78.510019',
    'Garden I': '38.035746,-78.504343',
    '7 11': '38.042177,-78.510163',
    'Thornton Hall': '38.033287,-78.509697',
    'Hereford Lawn': '38.030222,-78.520395',
    'Bryant Hall': '38.030384,-78.512894'
}
