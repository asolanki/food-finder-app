//
//  EventPoint.m
//  HoosEating
//
//  Created by Adarsh Solanki on 8/23/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import "EventPoint.h"

@implementation EventPoint

@synthesize name,location;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString *)name location:(NSString *)location coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        self.name = [name copy];
        self.location = [location copy];
        _coordinate = coordinate;
        
    }
    return self;
}

#pragma mark - MKAnnotation Protocol Methods


- (NSString *)title
{
    if ([name isKindOfClass:[NSNull class]])
        return @"No Name";
    else
        return name;
}

- (NSString *)subtitle 
{
    if ([location isKindOfClass:[NSNull class]])
        return @"No Location";
    else
        return location;
}

@end
