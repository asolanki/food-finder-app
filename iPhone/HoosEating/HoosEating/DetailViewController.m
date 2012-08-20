//
//  DetailViewController.m
//  HoosEating
//
//  Created by Adarsh Solanki on 8/9/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController
@synthesize date, location, time, description, event;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    
    [self.location setText:[self.event valueForKey:@"location"]];
    NSLog(@"\n\n%@\n", [self.event valueForKey:@"location"]);
    NSMutableString *dateStr = [NSMutableString stringWithString:
                                [[self.event valueForKey:@"start_time"] 
                                 substringFromIndex:11]];
    dateStr = [NSMutableString stringWithString:[dateStr substringToIndex:5]];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *month = [f numberFromString:[dateStr substringToIndex:2]];
    if ( [month intValue] > 12 )
    {
        month = [NSNumber numberWithInt: [month intValue] - 12];
    }
    // month check WORKS 
    // TODO: chnage dateStr, implement for endDate
    
    NSString *end = [NSString stringWithString:[[self.event valueForKey:@"end_time"] 
                                                substringFromIndex:11]];
    [dateStr appendFormat:@" - %@", [end substringToIndex:5]];
    
    
    // this should be just pulled from object, dateStr is a temp.
    
//    NSArray *dates = [dateStr componentsSeparatedByString:@"T"];
//    NSString *eventTime = [NSString stringWithFormat:@"%@%@%@", [dates objectAtIndex:0]
//                           , [dates objectAtIndex:1]];

                           
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd"];
//    NSString *date = [df stringFromDate:object.createdAt];
    
    
    [self.time setText:dateStr];
    
//    2012-08-19T23:40:20.000Z
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setLocation:nil];
    [self setTime:nil];
    [self setDate:nil];

    [self setDescription:nil];
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
