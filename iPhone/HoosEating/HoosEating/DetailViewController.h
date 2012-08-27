//
//  DetailViewController.h
//  HoosEating
//
//  Created by Adarsh Solanki on 8/9/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) PFObject *event;


@end
