//
//  HEAppDelegate.h
//  HoosEating
//
//  Created by Adarsh Solanki on 8/7/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

static NSString* const kLocationChangeNotification;


@interface HEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setCurrentLocation:(CLLocation *)currentLocation;

@end
