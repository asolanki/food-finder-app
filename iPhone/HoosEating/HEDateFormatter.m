//
//  HEDateFormatter.m
//  HoosEating
//
//  Created by Adarsh Solanki on 9/3/12.
//  Copyright (c) 2012 Adarsh Solanki. All rights reserved.
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
        
        if ( [[startTimeProcessed substringFromIndex:6] isEqualToString:[endTimeProcessed substringFromIndex:6]] ) {
            startTimeProcessed = [startTimeProcessed substringToIndex:5];
        }
        
        self.dateTime = [NSString stringWithFormat:@"%@ %@ - %@ %@", startProcessed, startTimeProcessed, endProcessed, endTimeProcessed];
        
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

@end
