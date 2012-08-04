Create 
    PFObject *foodEvent = [PFObject objectWithClassName:@"Newcomb Brownies"];
    [foodEvent setObject:[NSDate asfddasdfd] forKey:@"startTime"];
    [foodEvent setObject:[NSString initWithString:@"Newcomb Hall"] forKey:@"location"];
    ...
    [foodEvent save];
    // saveInBackground
    [foodEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // successful save
        } else {
            // oops
        }
    }];


    Parse app lazily creates class when first encountered (!!!!!)

Retrieve
    PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
    PFObject *foodEvent = [query getObjectWithId:@{ID}];

    NSDate *time = [foodEvent objectForKey:@"startTime"];
    NSString *location = [foodEvent objectForKey:@"location"];

    // three special vals: NSString objectId and NSDates updatedAt//createdAt

    [foodEvent refresh];

    [query getObjectInBackgroundWithId:@"{ID}
                                 block:^(PFObject *foodEvent, NSErorr *error) {
                                     if (!error) 
                                     else
                                 }];

Offline
    [foodScore saveEventually]
    // deleteEventually

increment
    [foodEvent incrementKey:@"count"];
    [foodEvent saveEventually];

Arrays
    [foodEvent addUniqueObjectsFromArray:[NSArray arrayWithObjects:@"peanut", @"shellfish", nil] forKey:@"allergens"];
    [foodEvent saveInBackground];

Relational
    PFObject *myLocation = [PFObject objectWithClassName:@"Location"];
    [myLocation setObject:@"Newcomb Hall" forKey:@"name"];

    PFObject *foodEvent = [PFObject objectWithClassName:@"FoodEvent"];
    [foodEvent setObject:myLocation forKey:@"parent"];
    [foodEvent saveInBackground] // saves both!

