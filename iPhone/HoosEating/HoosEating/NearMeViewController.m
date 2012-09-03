//
//  NearMeViewController.m
//  HoosEating
//
//  Created by Adarsh Solanki on 8/7/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import "NearMeViewController.h"
#import <Parse/Parse.h>
#import "DetailViewController.h"

@implementation NearMeViewController

@synthesize map, locationManager, idDict;

- (void)plotPositions:(NSArray *)data
{
    // remove existing annotations except user location
    for (id<MKAnnotation> annotation in map.annotations) {
        if ([annotation isKindOfClass:[EventPoint class]]) {
            [map removeAnnotation:annotation];
        }
    }
    
    EventPoint *event;
    
    for (PFObject *currObj in data)
    {
        PFGeoPoint *geo = [currObj objectForKey:@"coordinates"];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
        
        event = [[EventPoint alloc] initWithName:[currObj objectForKey:@"name"]
                                        location:[currObj objectForKey:@"location"]
                                      coordinate:coordinate
                                     description:[currObj objectForKey:@"description"]
                                       startTime:[currObj objectForKey:@"start_time"]
                                         endTime:[currObj objectForKey:@"end_time"]
                                        objectId:currObj.objectId];
        
//        idDict 
        NSLog(@"Parse ID for %@ - %@", [currObj objectForKey:@"name"], event.parseId);
        NSLog(@"%@ %@ %@ %@", event.description, event.start, event.end, event.location);
        
        [map addAnnotation:event];
//        [events addObject:event];
    }
}

//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation
//{
////    HEAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    [((HEAppDelegate *)[[UIApplication sharedApplication] delegate]) setCurrentLocation:newLocation];
//    NSDate* eventDate = newLocation.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (abs(howRecent) < 15.0)
//    {
//        NSLog(@"latitude: %.6f, longitude: %.6f\n", newLocation.coordinate.latitude,
//              newLocation.coordinate.longitude);
//    }
//}





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.map setDelegate:self];
    [self.map setShowsUserLocation:YES];
    
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager startUpdatingLocation];
        PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLatitude:self.locationManager.location.coordinate.latitude
                                                          longitude:self.locationManager.location.coordinate.longitude];
        
        PFQuery *q = [PFQuery queryWithClassName:@"FoodEvent"];
        [q whereKey:@"coordinates" nearGeoPoint:userLocation];
        
        [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [self plotPositions:objects];
            } else {

            }
        }];
    }
    else {
        NSLog(@"no location");
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                          message:@"We need location services to show the events near you!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
    
    
    
    
    
    //        [self plotPositions:[self pointsFromParse]];

    

}

//- (NSArray *)pointsFromParse
//{
//    PFGeoPoint *userLocation =
//        [PFGeoPoint geoPointWithLatitude:self.locationManager.location.coordinate.latitude
//                               longitude:self.locationManager.location.coordinate.longitude];
//    
//    PFQuery *q = [PFQuery queryWithClassName:@"FoodEvent"];
//    [q whereKey:@"coordinates" nearGeoPoint:userLocation];
//    
//    return [q findObjectsInBackgroundWithBlock:];
//}


- (void)viewDidUnload
{
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
//    MKAnnotationView *view = [views objectAtIndex:0];

    for (MKAnnotationView *view in views)
    {
        if ( [view.annotation isKindOfClass:[EventPoint class]] )
            {
                MKCoordinateSpan mapSpan = MKCoordinateSpanMake(.018, .002);
                CLLocationCoordinate2D userLocation =
                    CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude,
                                               self.locationManager.location.coordinate.longitude);
                


                MKCoordinateRegion center = MKCoordinateRegionMake(userLocation, mapSpan);
                        
                
                [mapView setRegion:center animated:YES];
                //    [mapView selectAnnotation:[view annotation] animated:YES];

            } else {
                [view setCanShowCallout:YES];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

                [view setRightCalloutAccessoryView:button];
            }
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
//    if (annotation == self.map.userLocation)
//    {
//        return nil;
//    }
    
    if ( [annotation isKindOfClass:[EventPoint class]])
    {
        static NSString *viewIdentifier = @"annotationView";
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:viewIdentifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:viewIdentifier];
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [button setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setRightCalloutAccessoryView:button];
        
        return annotationView;
    }
    
    return nil;
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
                      calloutAccessoryControlTapped:(UIControl *)control
{
    if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure){
        PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
        EventPoint *event = (EventPoint *) view.annotation ;

        NSLog(@"Clicked on %@ with id %@", event.name, event.parseId);
        NSLog(@"%@ %@ %@ %@", event.description, event.start, event.end, event.location);

        [query getObjectInBackgroundWithId:event.parseId
                                     block:^(PFObject *object, NSError *error) {
                                         if (!error) {
                                             NSLog(@"No Errors");
                                             DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetail"];
                                             dvc.event = object;
                                             [[self navigationController] pushViewController:dvc animated:YES];

                                         } else {
                                             NSLog(@"\n\nQuery error!");
                                         }
                                     }];
    }

    
}

@end
