//
//  NearMeViewController.h
//  HoosEating
//
//  Created by Adarsh Solanki on 8/7/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "EventPoint.h"

@interface NearMeViewController : UIViewController 
<MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIToolbar *upcomingButton;
@property (weak, nonatomic) IBOutlet UIToolbar *todayButton;
@property (strong, nonatomic) CLLocationManager *locationManager;



@end
