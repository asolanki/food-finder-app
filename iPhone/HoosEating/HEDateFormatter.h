//
//  HEDateFormatter.h
//  HoosEating
//
//  Created by Adarsh Solanki on 9/3/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HEDateFormatter : NSObject

@property (strong, nonatomic) NSString *rawStartDate;
@property (strong, nonatomic) NSString *rawEndDate;
@property (strong, nonatomic) NSDate *todayDate;
@property (strong, nonatomic) NSString *dateTime;


- (id)initWithStartDate:(NSString *)startDate endDate:(NSString *)endDate todayDate:(NSDate *)today;

// methods for specific date/time formatting




@end
