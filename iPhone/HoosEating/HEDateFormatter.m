//
//  HEDateFormatter.m
//  HoosEating
//
//  Created by Adarsh Solanki on 9/3/12.
//  Copyright (c) 2012 University of Virginia. All rights reserved.
//

#import "HEDateFormatter.h"


@implementation HEDateFormatter

@synthesize rawEndDate, rawStartDate, todayDate, dateTime;

- (id)initWithStartDate:(NSString *)start endDate:(NSString *)end todayDate:(NSDate *)today
{
    self = [super init];
    if (self) {
        self.rawEndDate = end;
        self.rawStartDate = start;
        self.todayDate = today;
        
        // 2012-08-31T00:00:00-04:00
        // 2012-08-29T18:00:00-04:00
        // 2012-08-31T23:59:00-04:00
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];        
        NSString *todayString = [dateFormat stringFromDate:todayDate];
        
        NSArray *startArray = [rawStartDate componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-T:/"]];
        NSArray *endArray = [rawEndDate componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-T:/"]];
        NSArray *todayArray = [todayString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-T:/"]];

        
        NSString *startProcessed = [self processedDateFromArray:startArray todayArray:todayArray];
        NSString *endProcessed = [self processedDateFromArray:endArray todayArray:todayArray];
        
        if ( [startProcessed isEqualToString:endProcessed] ) {
            endProcessed = @" ";
        }
        
        NSString *startTimeProcessed = [self processedTimeFromArray:startArray];
        NSString *endTimeProcessed = [self processedTimeFromArray:endArray];
        
        
        if ( [[startTimeProcessed substringFromIndex:6] isEqualToString:[endTimeProcessed substringFromIndex:6]] )
        {
            startTimeProcessed = [startTimeProcessed substringToIndex:5];
        }
        
        
        self.dateTime = [NSString stringWithFormat:@"%@ %@ - %@ %@", startProcessed, startTimeProcessed, endProcessed, endTimeProcessed];
        NSLog(@"%@ \n\n %@",startTimeProcessed , self.dateTime);
        
        // todo am/pm
        
        // if both hours are < 12, only one AM
        // if both are > 12, only one PM
        // else have both AM/PM respective
        
        
//        NSLog(@"sd: %@ \n ed: %@ \n st: %@ \n et: %@ ", self.startDate, self.endDate, self.startTime, self.endTime);
        
        
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

# pragma mark Processing Methods

- (NSString *)processedTimeFromArray:(NSArray *)startArray
{
    bool pm = false;
    NSString *hour = [startArray objectAtIndex:3];
    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    int hourNumber = [[format numberFromString:hour] intValue];
    
    if ( hourNumber > 12) {
        pm = true;
        hourNumber -= 12;
    }
    else if ( hourNumber == 0) {
        hourNumber = 12;
    }
    
    hour = [NSString stringWithFormat:@"%i", hourNumber];
    
    NSString *minute = [startArray objectAtIndex:4];
    int minuteNumber = [[format numberFromString:minute] intValue];
    
    if ( minuteNumber < 10 ) {
        minute = [NSString stringWithFormat:@"0%i", minuteNumber];
    }
    
    return [NSString stringWithFormat:@"%@:%@ %@", hour, minute, pm ? @"PM" : @"AM"];
    
}

- (NSString *)processedDateFromArray:(NSArray *)dateArray todayArray:(NSArray *)todayArray
{
    NSString *today = [todayArray objectAtIndex:0];
    NSString *date = [dateArray objectAtIndex:0];
    
    if ( [today isEqualToString:date] ) {
        // same year
        today = [todayArray objectAtIndex:1];
        date = [dateArray objectAtIndex:1];
        
        if ( [today isEqualToString:date] ) {
            // same month
            today = [todayArray objectAtIndex:2];
            date = [dateArray objectAtIndex:2];
            if ( [today isEqualToString:date] ) {
                // same day
                return @"Today";
            }
        }
    }
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    int dateNumber = [[format numberFromString:date] intValue];
    if (dateNumber < 10) {
        date = [NSString stringWithFormat:@"%i", dateNumber];
    }
    
    NSString *month = [dateArray objectAtIndex:1];
    
    if ( [month characterAtIndex:0] == '0' ) {
        month = [NSString stringWithFormat:@"%c", [month characterAtIndex:1]];
    }
    
    return [NSString stringWithFormat:@"%@/%@", month, date];
}




# pragma mark Date Methods




@end
