//
//  NSDateTools.m
//  MyTasks
//
//  Created by Stas Parechyn on 15.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import "NSDateTools.h"

@implementation NSDate (Tools)
- (NSDateComponents *)dateComponents {
    static dispatch_once_t onceToken;
    static NSCalendar *calendar;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    return [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    return dateFormatter;
}

- (NSInteger )year {
    return [[self dateComponents] year];
}

- (NSInteger )month {
    return [[self dateComponents] month];
}

- (NSInteger )day {
    return [[self dateComponents] day];
}

- (NSInteger )hours {
    return [[self dateComponents] hour];
}

- (NSInteger )minutes {
    return [[self dateComponents] minute];
}

- (NSString *)stringFormat {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    return [dateFormatter stringFromDate:self];
}

@end
