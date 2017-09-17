//
//  TasksList+CoreDataClass.h
//  MyTasks
//
//  Created by Stas Parechyn on 15.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSObject;

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    kTaskStateNotDefined = 0,
    kTaskStateNew = 1,
    kTaskStateInProgress = 2,
    kTaskStateFinished = 3
} TaskStatus;

@interface TasksList : NSManagedObject
@property TaskStatus state;

@property (nonatomic, readonly, copy) NSDate * _Nonnull estimatedTimeDate;
@property (nonatomic, readonly) NSTimeInterval estimatedTimeInterval;
@property (nonatomic, readonly, copy) NSMutableString * _Nonnull stringFromEstimatedTimeInterval;

- (TaskStatus)state;
- (void)setState:(TaskStatus)status;

- (void)setTaskCompletePercents:(int16_t)completionPercent;
@end

NS_ASSUME_NONNULL_END

#import "TasksList+CoreDataProperties.h"
