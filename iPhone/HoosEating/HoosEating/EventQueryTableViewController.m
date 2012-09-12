//
//  EventQueryTableViewController.m
//  HoosEating
//
//  Created by Adarsh Solanki on 8/19/12.
//  Copyright (c) 2012 Adarsh Solanki. All rights reserved.
//

#import "EventQueryTableViewController.h"
#import <Parse/Parse.h>




@implementation EventQueryTableViewController

@synthesize table;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [self initWithStyle:style className:@"FoodEvent"];
    if (self)
    {
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setRowHeight:60];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
}

- (PFQuery *)queryForTable
{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:date];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
    
//  // If no objects are loaded in memory, we look to the cache first to fill the table
//	// and then subsequently do a query against the network.
//	if ([self.objects count] == 0) {
//		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//	}
    
    [query whereKey:@"end_time" greaterThanOrEqualTo:dateString];
    [query orderByAscending:@"start_time"];
    [[PFUser currentUser] incrementKey:@"RunCount"];
    [[PFUser currentUser] saveInBackground];

    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object 
{
    static NSString *CellIdentifier = @"TableCell";
    HETableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HETableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    }
    
    cell.name.text = [object objectForKey:@"name"];
    cell.location.text = [object objectForKey:@"location"];
    
    // color from hex
    int c = 0x10263cff;
    UIColor *color = [UIColor colorWithRed:((c>>24)&0xFF)/255.0
                                     green:((c>>16)&0xFF)/255.0
                                      blue:((c>>8)&0xFF)/255.0
                                     alpha:((c)&0xFF)/255.0];

    cell.location.textColor = color;
    
    cell.start.textColor = [UIColor darkTextColor];
    
    // parse MM/DD from startTime in ISO format
    NSString *startTime = [object objectForKey:@"start_time"];
    HEDateFormatter *format = [[HEDateFormatter alloc] initWithStartDate:startTime endDate:startTime todayDate:[NSDate date]];
    startTime = [format dateTime];
    startTime = [[startTime componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] objectAtIndex:0];
    
    cell.start.text = startTime;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HETableCell *cell = (HETableCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    int c = 0x10263cff;
    UIColor *color = [UIColor colorWithRed:((c>>24)&0xFF)/255.0
                                     green:((c>>16)&0xFF)/255.0
                                      blue:((c>>8)&0xFF)/255.0
                                     alpha:((c)&0xFF)/255.0];
    
    cell.location.textColor = color;
    cell.start.textColor = [UIColor darkTextColor];
    cell.name.textColor = color;
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetail"];
    detail.event = [self objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:detail animated:YES];
}


@end
