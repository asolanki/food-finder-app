//
//  DetailViewController.m
//  HoosEating
//
//  Created by Adarsh Solanki on 8/9/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HEDateFormatter.h"

@implementation DetailViewController
@synthesize name;
@synthesize mapButton;
@synthesize dateTime, location, description, event;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
    // foo:withBar:andBar
}
- (IBAction)seeOnMap:(id)sender
{
    PFGeoPoint *geo = [self.event objectForKey:@"coordinates"];
    NSString *coordinates = [NSString stringWithFormat:@"%f,%f",geo.latitude, geo.longitude];
    
    NSString *mapString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current+Location&daddr=%@",coordinates] ;
    
//    NSLog([NSString stringWithFormat:@"Coordinates: %@",coordinates]);
//    NSLog([NSString stringWithFormat:@"Map string: %@", mapString]);
//    &saddr=Were+St&daddr=Kings+Hwy+to:Princes+Hwy+to:Princes+Hwy+to:Monaro+Hwy+to:-35.43483,149.112175
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapString]];
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
    UIFont *font = [UIFont fontWithName:@"Alégre Sans" size:65.54];
    [self.location setText:[NSString stringWithFormat:@"@%@",[self.event valueForKey:@"location"]]];
    [self.location setFont:font];
    [self.location setAdjustsFontSizeToFitWidth:YES];
    [self.location setMinimumFontSize:36];
    [self.location setShadowColor:[UIColor whiteColor]];
    [self.location setShadowOffset:CGSizeMake(1, 2)];
    
    [self.name setText:[self.event valueForKey:@"name"]];
    // self.location.setText(self.event(valueForKey(location)));
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

//    2012-08-19T23:40:20.000Z

//    dateStr = [self.event objectForKey:@"start_time"];
//
//    [dateStr replaceOccurrencesOfString:@"-"
//                             withString:@"/"
//                                options:NSLiteralSearch
//                                  range:NSMakeRange(0, 6)];
//    dateStr2 = [[dateStr substringToIndex:10] substringFromIndex:5];
//
//    
//    [self.date setText:dateStr2];
//    font = [UIFont fontWithName:@"Alte Haas Grotesk" size:30];
//
//    [self.date setFont:font];
//    [self.date setMinimumFontSize:30];
//    [self.location setAdjustsFontSizeToFitWidth:YES];
//
//    [self.date setShadowColor:[UIColor whiteColor]];
//    [self.date setShadowOffset:CGSizeMake(1, 1)];
    
    
    
    self.description.layer.cornerRadius = 10;
//    self.description.layer.shadowOffset = CGSizeMake(2, 2);
//    self.description.layer.shadowColor = [[UIColor darkTextColor] CGColor];
//    self.description.layer.shadowOpacity = 1.0;
//    self.description.layer.shadowRadius = 5;
//    self.description.layer.borderColor = [[UIColor darkGrayColor] CGColor];

    

    [self.description setText:[self.event objectForKey:@"description"]];
    

    
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setLocation:nil];
    [self setDateTime:nil];

    [self setDescription:nil];
    [self setMapButton:nil];
    [self setName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
