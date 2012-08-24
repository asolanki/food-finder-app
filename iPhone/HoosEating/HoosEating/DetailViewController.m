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
    
    UIFont *font = [UIFont fontWithName:@"Alégre Sans" size:65.54];
    [self.location setText:[self.event valueForKey:@"location"]];
    [self.location setFont:font];
    [self.location setAdjustsFontSizeToFitWidth:YES];
    [self.location setMinimumFontSize:48];
    [self.location setShadowColor:[UIColor whiteColor]];
    [self.location setShadowOffset:CGSizeMake(2, 2)];
    
//    
//    CGRect frame = location.frame;
//    CGFloat fontSize = 48.0;
//    // width 240  height 55
//    frame.size = [location.text sizeWithFont:font
//                              minFontSize:location.minimumFontSize
//                           actualFontSize:&fontSize
//                                 forWidth:320
//                               lineBreakMode:location.lineBreakMode];
//    frame.origin = CGPointMake(70, 170);
//    
//    [self.location setFrame:frame];

    
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

    NSString *startDateNumber = [dateStr substringFromIndex:3];
    dateStr = [NSMutableString stringWithFormat:@"%@:%@ - ", month, startDateNumber];
    // at this pt dateStr is "1:30 - "
    
    NSString *end = [NSString stringWithString:[[self.event valueForKey:@"end_time"] 
                                                substringFromIndex:11]];
    
    NSString *dateStr2 = [NSMutableString stringWithString:[end substringToIndex:5]];
    NSLog(@"dateStr2: %@", dateStr2);
    month = [f numberFromString:[dateStr2 substringToIndex:2]];
    if ( [month intValue] > 12 )
    {
        month = [NSNumber numberWithInt: [month intValue] - 12];
    }
    
    NSString *endDateNumber = [dateStr2 substringFromIndex:3];
    dateStr2 = [NSMutableString stringWithFormat:@"%@:%@", month, endDateNumber];

    NSLog(@"dateStr: %@", dateStr);

    [dateStr appendFormat:@"%@", dateStr2];
    NSLog(@"\n\ndateStr: %@", dateStr);
//    [dateStr appendFormat:@"%@", [end substringToIndex:5]];
    
    
    // this should be just pulled from object, dateStr is a temp.
    
//    NSArray *dates = [dateStr componentsSeparatedBySt`ring:@"T"];
//    NSString *eventTime = [NSString stringWithFormat:@"%@%@%@", [dates objectAtIndex:0]
//                           , [dates objectAtIndex:1]];

                           
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd"];
//    NSString *date = [df stringFromDate:object.createdAt];
    
    
    [self.time setText:dateStr];
    font = [UIFont fontWithName:@"Alte Haas Grotesk" size:30];
    [self.time setFont:font];
//    [self.time setAdjustsFontSizeToFitWidth:YES];
    [self.time setMinimumFontSize:30];
    
    [self.time setShadowColor:[UIColor whiteColor]];
    [self.time setShadowOffset:CGSizeMake(1, 1)];

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
