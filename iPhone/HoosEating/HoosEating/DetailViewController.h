//
//  DetailViewController.h
//  HoosEating
//
//  Created by Adarsh Solanki on 8/9/12.
//  Copyright (c) 2012 Adarsh Solanki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface DetailViewController : UIViewController <MBProgressHUDDelegate> {
    UIActivityIndicatorView *activityIndicator;
}

@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UITextView *descriptionBG;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) PFObject *event;
@property (weak, nonatomic) IBOutlet UIButton *directions;

- (IBAction)downAction:(UIButton *)sender;

- (IBAction)upAction:(id)sender;


@end
