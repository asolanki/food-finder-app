//
//  HETableCell.h
//  HoosEating
//
//  Created by Adarsh Solanki on 9/7/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HETableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *start;

@end
