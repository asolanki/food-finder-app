//
//  DetailViewController.m
//  HoosEating
//
//  Created by Adarsh Solanki on 8/9/12.
//  Copyright (c) 2012 Adarsh Solanki. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HEDateFormatter.h"


@implementation DetailViewController
@synthesize directions;
@synthesize name;
@synthesize descriptionBG;
@synthesize mapButton;
@synthesize dateTime, location, description, event;

# pragma mark Custom Methods

- (void)setUpDetailView
{
    UIFont *font = [UIFont fontWithName:@"Alégre Sans" size:65.54];
    [self.location setText:[NSString stringWithFormat:@"@%@",[self.event valueForKey:@"location"]]];
    [self.location setFont:font];
    [self.location setAdjustsFontSizeToFitWidth:YES];
    [self.location setMinimumFontSize:36];
    [self.location setShadowColor:[UIColor whiteColor]];
    [self.location setShadowOffset:CGSizeMake(1, 2)];
    
    [self.name setText:[self.event valueForKey:@"name"]];
    [self.name setFont:font];
    [self.name setAdjustsFontSizeToFitWidth:YES];
    [self.name setMinimumFontSize:36];
    [self.name setShadowColor:[UIColor whiteColor]];
    [self.name setShadowOffset:CGSizeMake(1, 2)];
    
    HEDateFormatter *format = [[HEDateFormatter alloc] initWithStartDate:[self.event objectForKey:@"start_time"]
                                                                 endDate:[self.event objectForKey:@"end_time"]
                                                               todayDate:[NSDate date]];
    
    
    font = [UIFont fontWithName:@"Alte Haas Grotesk" size:24];
    [self.dateTime setText:[format dateTime]];
    
    [self.dateTime setFont:font];
    [self.dateTime setMinimumFontSize:24];
    [self.dateTime setAdjustsFontSizeToFitWidth:YES];
    
    [self.dateTime setShadowColor:[UIColor whiteColor]];
    [self.dateTime setShadowOffset:CGSizeMake(1, 1)];
    
    // [UIColor colorWithRed:16 green:38 blue:60 alpha:1]    
    
    self.description.layer.cornerRadius = 10;
    [self.description setDataDetectorTypes:UIDataDetectorTypeLink];
    self.descriptionBG.layer.cornerRadius = 10;    
    
    [self.description setText:[self.event objectForKey:@"description"]];
    
    
    
}

- (IBAction)seeOnMap:(id)sender
{
    PFGeoPoint *geo = [self.event objectForKey:@"coordinates"];
    NSString *coordinates = [NSString stringWithFormat:@"%f,%f",geo.latitude, geo.longitude];
    
    NSString *mapString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current+Location&daddr=%@",coordinates] ;    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapString]];
}

# pragma mark Default Methods

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
    // foo:withBar:andBar
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
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(0, 0, 40, 40);
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[activityIndicator startAnimating];

    [self setUpDetailView];
    [super viewDidLoad];

    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityIndicator stopAnimating];
   
    
}

- (void)viewDidUnload
{
    [self setLocation:nil];
    [self setDateTime:nil];

    [self setDescription:nil];
    [self setMapButton:nil];
    [self setName:nil];
    [self setDescriptionBG:nil];
    [self setDirections:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)downAction:(UIButton *)sender
{
    CGPoint loc = directions.center;
    directions.center = CGPointMake(loc.x, loc.y+2);
}

- (IBAction)upAction:(id)sender
{
    CGPoint loc = directions.center;
    directions.center = CGPointMake(loc.x, loc.y-2);
    
}

@end
