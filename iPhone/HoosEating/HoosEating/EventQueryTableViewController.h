//
//  EventQueryTableViewController.h
//  HoosEating
//
//  Created by Adarsh Solanki on 8/19/12.
//  Copyright (c) 2012 Adarsh Solanki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import <Parse/Parse.h>

@interface EventQueryTableViewController : PFQueryTableViewController
    <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;

@end
