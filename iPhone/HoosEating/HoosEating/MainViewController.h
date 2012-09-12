//
//  MainViewController.h
//  HoosEating
//
//  Created by Adarsh Solanki on 8/7/12.
//  Copyright (c) 2012 Adarsh Solanki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *comingButton;
@property (weak, nonatomic) IBOutlet UIImageView *nearButton;


- (BOOL)hasConnectivity;
- (void)internetMessage;

- (IBAction)comingDownAction:(UIButton *)sender;
- (IBAction)nearDownAction:(UIButton *)sender;

- (IBAction)comingUpAction:(id)sender;
- (IBAction)nearUpAction:(UIButton *)sender;

- (IBAction)nearSegue:(UIButton *)sender;
- (IBAction)comingSegue:(UIButton *)sender;

@end
