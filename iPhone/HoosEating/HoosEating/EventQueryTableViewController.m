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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [self initWithStyle:style className:@"FoodEvent"];
    if (self) {
        // This table displays items in the FoodEvent class
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setRowHeight:60];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
    
    [query orderByDescending:@"start_time"];
    
    // TODO
    // make two arrays, one for Today, one for Future.  Make them
    // response to a UI Toggle Element.
    // Bind the Toggle action to loadObjects


    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object 
{
    static NSString *CellIdentifier = @"EventCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // background image
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    UIImage *image = [UIImage imageNamed:@"cell2.png"];
    imageView.image = image;
    
    cell.backgroundView = imageView;
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                 [object objectForKey:@"location"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetail"];
    detail.event = [self objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:detail animated:YES];
}


@end
