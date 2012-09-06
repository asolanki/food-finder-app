//
//  EventPoint.m
//  HoosEating
//
//  Created by Adarsh Solanki on 8/23/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import "EventPoint.h"

@implementation EventPoint

@synthesize name,location,description,start,end,parseId,title = _title,subtitle = _subtitle;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString *)theName
          location:(NSString *)theLocation
        coordinate:(CLLocationCoordinate2D)coordinate
       description:(NSString *)theDescription
         startTime:(NSString *)theStart
           endTime:(NSString *)theEnd
          objectId:(NSString *)theParseId
{
    if ((self = [super init]))
    {
//        self.name = theName;
//        self.location = theLocation;
//        self.description = theDescription;
//        self.start = theStart;
//        self.end = theEnd;
//        self.parseId = theParseId;
        

        _title = theName;
        _subtitle = theLocation;
        _coordinate = coordinate;
    }
    return self;
}

#pragma mark - MKAnnotation Protocol Methods


- (NSString *)title
{
    return _title;
}

- (NSString *)subtitle
{
    return _subtitle;
}

@end
