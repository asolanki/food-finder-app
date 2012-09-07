//
//  EventPoint.h
//  HoosEating
//
//  Created by Adarsh Solanki on 8/23/12.
//  Copyright (c) 2012 Adarsh Solanki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EventPoint : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D _coordinate;

}

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *location;
@property (weak, nonatomic) NSString *description;
@property (weak, nonatomic) NSString *start;
@property (weak, nonatomic) NSString *end;
@property (weak, nonatomic) NSString *parseId;


@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString *)theName
          location:(NSString *)theLocation
        coordinate:(CLLocationCoordinate2D)coordinate
       description:(NSString *)theDescription
         startTime:(NSString *)theStart
           endTime:(NSString *)theEnd
          objectId:(NSString *)theParseId;

@end
