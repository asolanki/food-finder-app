//
//  EventQueryTableViewController.m
//  HoosEating
//
//  Created by Adarsh Solanki on 8/19/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import "EventQueryTableViewController.h"
#import <Parse/Parse.h>

@implementation EventQueryTableViewController

@synthesize table;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [self initWithStyle:style className:@"FoodEvent"];
    if (self) {
        // This table displays items in the FoodEvent class
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
    
    [query orderByDescending:@"start_time"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                 [object objectForKey:@"description"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetail"];
    detail.event = [self objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:detail animated:YES];
}


@end
