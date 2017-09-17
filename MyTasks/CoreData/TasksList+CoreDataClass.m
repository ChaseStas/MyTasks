//
//  TasksList+CoreDataClass.m
//  MyTasks
//
//  Created by Stas Parechyn on 15.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//
//

#import "TasksList+CoreDataClass.h"

@implementation TasksList
@dynamic state;

- (void)awakeFromInsert {
    [super awakeFromInsert];
    
    NSDate *date = [NSDate date];
    self.startDate = date;
    self.dueDate = date;
    self.estimatedTime = 60;
    self.state = kTaskStateNotDefined;
    self.completionPercent = 0;
}

#pragma mark - Percent of completion
- (void)setTaskCompletePercents:(int16_t)completionPercent {
    self.completionPercent = completionPercent;
    if (completionPercent == 100) {
        self.state = kTaskStateFinished;
    }
    else {
        self.state = kTaskStateInProgress;
    }
}

#pragma mark - State

- (TaskStatus)state {
    return (TaskStatus)self.stateInt;
}
- (void)setState:(TaskStatus)status {
    self.stateInt = (int64_t)status;
}

#pragma mark - Time Interval and Dates

- (NSTimeInterval)estimatedTimeInterval {
    return (NSTimeInterval)self.estimatedTime;
}

- (NSDate *)estimatedTimeDate {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    NSInteger ti = (NSInteger)self.estimatedTimeInterval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    dateComp.hour = hours;
    dateComp.minute = minutes;
    dateComp.timeZone = [NSTimeZone systemTimeZone];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calendar dateFromComponents:dateComp];
}

- (NSMutableString *)stringFromEstimatedTimeInterval {
    NSInteger ti = (NSInteger)self.estimatedTimeInterval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    NSMutableString *timeString = [NSMutableString string];
    if (hours > 0) {
        [timeString appendString:[NSString stringWithFormat:@"%ld %@",(long)hours, NSLocalizedString(@"hour", nil)]];
    }
    if (minutes > 0) {
        [timeString appendString:[NSString stringWithFormat:@" %ld %@",(long)minutes,NSLocalizedString(@"minute", nil)]];
    }
    return timeString;
}


@end
