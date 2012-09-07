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
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

}

- (PFQuery *)queryForTable {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:date];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
    [query whereKey:@"end_time" greaterThanOrEqualTo:dateString];
    [query orderByAscending:@"start_time"];
    
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
    
    NSString *startTime = [object objectForKey:@"start_time"];

    HEDateFormatter *format = [[HEDateFormatter alloc] initWithStartDate:startTime endDate:startTime todayDate:[NSDate date]];
    
    
    
    startTime = [format dateTime];

    startTime = [[startTime componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] objectAtIndex:0];
    
    cell.start.text = startTime;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetail"];
    detail.event = [self objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:detail animated:YES];
}


@end
