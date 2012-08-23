//
//  EventPoint.h
//  HoosEating
//
//  Created by Adarsh Solanki on 8/23/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EventPoint : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D _coordinate;

}

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *location;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString *)name location:(NSString *)location coordinate:(CLLocationCoordinate2D)coordinate;


@end
