//
//  EventTableViewController.h
//  HoosEating
//
//  Created by Adarsh Solanki on 8/7/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface EventTableViewController : UITableViewController 
    <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (strong, nonatomic) NSMutableArray *events;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
