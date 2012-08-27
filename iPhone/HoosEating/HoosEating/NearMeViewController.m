//
//  NearMeViewController.m
//  HoosEating
//
//  Created by Adarsh Solanki on 8/7/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import "NearMeViewController.h"
#import "HEAppDelegate.h"
#import <Parse/Parse.h>

@implementation NearMeViewController

@synthesize map, locationManager;
@synthesize upcomingButton;
@synthesize todayButton;

- (void)plotPositions:(NSArray *)data
{
    // remove existing annotations except user location
    for (id<MKAnnotation> annotation in map.annotations) {
        if ([annotation isKindOfClass:[EventPoint class]]) {
            [map removeAnnotation:annotation];
        }
    }
    
    // get the places from Parse
        // TODO
    
    
    
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(38.036676,-78.506028);
//    EventPoint *event1 = [[EventPoint alloc] initWithName:@"lol" location:@"lollers" coordinate:coordinate];
//    
//    [map addAnnotation:event1];
//    NSLog(@"Debug event has been annotated at 33x33");

    // add the places
    for (int i=0; i<[data count]; i++) 
    {
        PFObject *currObj = [data objectAtIndex:i];
        NSString *eventName = [currObj objectForKey:@"name"];
        NSString *locationName = [currObj objectForKey:@"location"];
        PFGeoPoint *geo = [currObj objectForKey:@"coordinates"];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
        
        EventPoint *event = [[EventPoint alloc] initWithName:eventName
                                                    location:locationName
                                                  coordinate:coordinate];
        
        // TODO add a flag as a param that is Today/Future and only adds annotations
        // for the correct ones.
        // this will require some sort of date format method.
        
        [map addAnnotation:event];
    }
        
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    HEAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setCurrentLocation:newLocation];
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        NSLog(@"latitude: %.6f, longitude: %.6f\n", newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
}

- (void)locationDidChange:(NSNotification *)note
{
//    map.userLocation = n
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.map setDelegate:self];
    [self.map setShowsUserLocation:YES];

    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
//    [self plotPositions:nil];
    
    [self plotPositions:[self pointsFromParse]];


}

- (NSArray *)pointsFromParse
{
    PFQuery *q = [PFQuery queryWithClassName:@"FoodEvent"];
    [q whereKey:@"coordinates" nearGeoPoint:[PFGeoPoint geoPointWithLatitude:self.locationManager.location.coordinate.latitude
                                                                   longitude:self.locationManager.location.coordinate.longitude]];
    return [q findObjects];
}


- (void)viewDidUnload
{
    [self setUpcomingButton:nil];
    [self setTodayButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - MKMapViewDelegate methods

// when annotations are added
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
    // TODO -- make this into a centered on User but scaled based on POI animation
    
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 1000, 1000);
    MKAnnotationView *view = [views objectAtIndex:0];

    MKCoordinateSpan span = MKCoordinateSpanMake(.018, .002);
    
    MKCoordinateRegion region2 = MKCoordinateRegionMake([[view annotation] coordinate], span);
    
    [mapView setRegion:region2 animated:YES];
}

@end
