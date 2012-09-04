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
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;


- (id)initWithStartDate:(NSString *)startDate endDate:(NSString *)endDate;

@end
