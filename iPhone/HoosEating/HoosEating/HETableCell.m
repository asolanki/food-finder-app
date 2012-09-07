//
//  HETableCell.m
//  HoosEating
//
//  Created by Adarsh Solanki on 9/7/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import "HETableCell.h"

@implementation HETableCell
@synthesize name;
@synthesize location;
@synthesize start;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"HETableCell"
                                                          owner:self
                                                        options:nil];
        self = [nibArray objectAtIndex:0];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
