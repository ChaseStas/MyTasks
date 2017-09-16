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
    static NSDateComponents *components;
    dispatch_once(&onceToken, ^{
        components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    });
    return components;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    return dateFormatter;
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
