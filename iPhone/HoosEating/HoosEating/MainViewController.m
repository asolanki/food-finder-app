//
//  MainViewController.m
//  HoosEating
//
//  Created by Adarsh Solanki on 8/7/12.
//  Copyright (c) 2012 Adarsh Solanki. All rights reserved.
//

#import "MainViewController.h"
#import <Parse/Parse.h>
#import "NearMeViewController.h"
#import "EventQueryTableViewController.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>


@implementation MainViewController
@synthesize comingButton;
@synthesize nearButton;

- (BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)internetMessage
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                      message:@"Hoo's Eating requires a working Internet Connection!"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [self.view addSubview:message];
    
    [message show];
}

#pragma mark Default Methods

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
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

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setComingButton:nil];
    [self setNearButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - Touch Responses

- (IBAction)nearDownAction:(UIButton *)sender
{
    CGPoint loc = nearButton.center;
    nearButton.center = CGPointMake(loc.x, loc.y+2);
}

- (IBAction)comingUpAction:(id)sender
{
    CGPoint loc = comingButton.center;
    comingButton.center = CGPointMake(loc.x, loc.y-2);
    
}

- (IBAction)nearUpAction:(UIButton *)sender
{
    CGPoint loc = nearButton.center;
    nearButton.center = CGPointMake(loc.x, loc.y-2);
    
}

- (IBAction)comingDownAction:(UIButton *)sender
{
    CGPoint loc = comingButton.center;
    comingButton.center = CGPointMake(loc.x, loc.y+2);
}

# pragma mark Segues

- (IBAction)nearSegue:(UIButton *)sender
{
    if ( [self hasConnectivity] )
    {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"NearMe"]
                                             animated:YES];
    } else
    {
        [self internetMessage];
    }
}

- (IBAction)comingSegue:(UIButton *)sender
{
    if ( [self hasConnectivity] )
    {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"EventTable"]
                                             animated:YES];
    } else
    {
        [self internetMessage];
    }
}



@end
