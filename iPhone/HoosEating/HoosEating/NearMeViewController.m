//
//  NearMeViewController.m
//  HoosEating
//
//  Created by Adarsh Solanki on 8/7/12.
//  Copyright (c) 2012 Adarsh Solanki. All rights reserved.

#import "NearMeViewController.h"
#import <Parse/Parse.h>
#import "DetailViewController.h"

@implementation NearMeViewController

@synthesize map, locationManager, PFDict, geoDict;

- (void)plotPositions:(NSArray *)data
{
    // remove existing annotations except user location
    for (id<MKAnnotation> annotation in map.annotations) {
        if ([annotation isKindOfClass:[EventPoint class]]) {
            [map removeAnnotation:annotation];
        }
    }
    
    // iteratively add each PFObject from array to map and to PFDict
    EventPoint *event;
    NSString *temp;
    CLLocationCoordinate2D coordinate;
    PFGeoPoint *geo;
    for (PFObject *currObj in data)
    {
        int status = 0;
        geo = [currObj objectForKey:@"coordinates"];
        temp = [NSString stringWithFormat:@"%f%f", geo.latitude, geo.longitude];
        
        
        if ( [geoDict objectForKey:temp] == nil )
        {
            // unique location
            [geoDict setObject:[NSNumber numberWithInt:1] forKey:temp];
            status = 0;
        }
        else
        {
            // duplicate location
            // increment counter for location

            NSNumber *curr = (NSNumber *)[geoDict objectForKey:temp];
            NSLog(@"Duplicate! %@", curr);
            status = [curr intValue];
            [geoDict setObject:[NSNumber numberWithInt:[curr intValue]+1] forKey:temp];
        }
        

        switch (status) {
            case 0:
                NSLog(@"case 0");
                coordinate = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
                break;
            case 1:
                NSLog(@"case 1");
                coordinate = CLLocationCoordinate2DMake(geo.latitude + 0.0003, geo.longitude + 0.0003);
                break;
            case 2:
                NSLog(@"case 2");
                coordinate = CLLocationCoordinate2DMake(geo.latitude - 0.0003, geo.longitude - 0.0003);
                break;
            case 3:
                NSLog(@"case 3");
                coordinate = CLLocationCoordinate2DMake(geo.latitude - 0.0003, geo.longitude + 0.0003);
                break;
            case 4:
                NSLog(@"case 4");
                coordinate = CLLocationCoordinate2DMake(geo.latitude + 0.0003, geo.longitude - 0.0003);
                break;

            default:
                break;
        }

        
        
        
        event = [[EventPoint alloc] initWithName:[currObj objectForKey:@"name"]
                                        location:[currObj objectForKey:@"location"]
                                      coordinate:coordinate
                                     description:[currObj objectForKey:@"description"]
                                       startTime:[currObj objectForKey:@"start_time"]
                                         endTime:[currObj objectForKey:@"end_time"]
                                        objectId:currObj.objectId];
        
        
        // index all annotation-backing objects by their name and location concatenated.
        temp = [NSString stringWithFormat:@"%@%@", event.name, event.location];
        [PFDict setObject:currObj forKey:temp];
//        NSLog(@"Plotting %@ at %@", event.name, event.location);
        
        [map addAnnotation:event];
    }
    
}



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
    [self setPFDict:[NSMutableDictionary dictionary]];
    [self setGeoDict:[NSMutableDictionary dictionary]];
    [self.map setDelegate:self];
    [self.map setShowsUserLocation:YES];
    
    if ([CLLocationManager locationServicesEnabled] &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager startUpdatingLocation];
        PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLatitude:self.locationManager.location.coordinate.latitude
                                                          longitude:self.locationManager.location.coordinate.longitude];
        
        PFQuery *q = [PFQuery queryWithClassName:@"FoodEvent"];
        [q whereKey:@"coordinates" nearGeoPoint:userLocation];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [format stringFromDate:date];

        [q whereKey:@"end_time" greaterThanOrEqualTo:dateString];
        
        [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
//                NSLog(@"%@", objects);
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

        message.delegate = self;
        [self.view addSubview:message];

        [message show];
    
    
    }
    

    

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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
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
    EventPoint *event = (EventPoint *) view.annotation;
    
    PFObject *obj = [PFDict objectForKey:[NSString stringWithFormat:@"%@%@",event.name,event.location]];
//    NSLog(@"%@%@", event.name, event.location);
    DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetail"];
    dvc.event = obj;
    [self.navigationController pushViewController:dvc animated:YES];
    
    
    
//    [query getObjectInBackgroundWithId:id
//                                 block:^(PFObject *object, NSError *error) {
//                                     if (!error) {
//                                         NSLog(@"No Errors");
//                                         DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetail"];
//                                         dvc.event = object;
//                                         [[self navigationController] pushViewController:dvc animated:YES];
//                                         
//                                     } else {
//                                         NSLog(@"\n\nQuery error!");
//                                     }
//                                 }];

    
}

# pragma mark UIAlertViewDelegate methods
    
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
//    }
}
    
    
    
@end
