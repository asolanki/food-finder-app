//
//  HEDateFormatter.m
//  HoosEating
//
//  Created by Adarsh Solanki on 9/3/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import "HEDateFormatter.h"


@implementation HEDateFormatter

@synthesize rawEndDate, rawStartDate, startDate, endDate, startTime, endTime;

- (id)initWithStartDate:(NSString *)theStart endDate:(NSString *)theEnd;
{
    self = [super init];
    if (self) {
        self.rawEndDate = theEnd;
        self.rawStartDate = theStart;
        
        // 2012-08-31T00:00:00-04:00
        // 2012-08-29T18:00:00-04:00
        // 2012-08-31T23:59:00-04:00
        
        self.startDate = [self.rawStartDate substringToIndex:10];
        self.startDate = [self.startDate substringFromIndex:5];
        self.startDate = [self.startDate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        
        self.endDate = [self.rawEndDate substringToIndex:10];
        self.endDate = [self.endDate substringFromIndex:5];
        self.endDate = [self.endDate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        
        self.startTime = [self.rawStartDate substringFromIndex:11];
        self.startTime = [self.startTime substringToIndex:5];
        
        self.endTime = [self.rawEndDate substringFromIndex:11];
        self.endTime = [self.endTime substringToIndex:5];
        
        // todo am/pm
        
        // if both hours are < 12, only one AM
        // if both are > 12, only one PM
        // else have both AM/PM respective
        
        
        NSLog(@"sd: %@ \n ed: %@ \n st: %@ \n et: %@ ", self.startDate, self.endDate, self.startTime, self.endTime);
        
        
//        NSString *amPm = @"AM";
//        NSString *amPm2 = @"AM";
//        
//        NSMutableString *dateStr = [NSMutableString stringWithString:
//                                    [[self.event valueForKey:@"start_time"]
//                                     substringFromIndex:11]];
//        dateStr = [NSMutableString stringWithString:[dateStr substringToIndex:5]];
//        
//        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//        [f setNumberStyle:NSNumberFormatterDecimalStyle];
//        
//        NSNumber *month = [f numberFromString:[dateStr substringToIndex:2]];
//        if ( [month intValue] > 12 )
//        {
//            month = [NSNumber numberWithInt: [month intValue] - 12];
//            amPm = @"PM";
//        } else if ( [month intValue] < 1)
//        {
//            month = [NSNumber numberWithInt: 12];
//        }
//        
//        NSString *startDateNumber = [dateStr substringFromIndex:3];
//        dateStr = [NSMutableString stringWithFormat:@"%@:%@ - ", month, startDateNumber];
//        // at this pt dateStr is "1:30 - "
//        
//        NSString *end = [NSString stringWithString:[[self.event valueForKey:@"end_time"]
//                                                    substringFromIndex:11]];
//        
//        NSString *dateStr2 = [NSMutableString stringWithString:[end substringToIndex:5]];
//        month = [f numberFromString:[dateStr2 substringToIndex:2]];
//        if ( [month intValue] > 12 )
//        {
//            month = [NSNumber numberWithInt: [month intValue] - 12];
//            amPm2 = @"PM";
//        }
//        
//        NSString *endDateNumber = [dateStr2 substringFromIndex:3];
//        dateStr2 = [NSMutableString stringWithFormat:@"%@:%@", month, endDateNumber];
//        
//        
//        [dateStr appendFormat:@"%@", dateStr2];
//        
//        if (![amPm isEqualToString:amPm2]) {
//            NSRange range = [dateStr rangeOfString:@" -"];
//            [dateStr insertString:amPm atIndex:range.location];
//        }
//        [dateStr appendFormat:@"%@", amPm2];
//        
//        NSLog(@"\n\ndateStr: %@", dateStr);


    }
    return self;
}

@end
