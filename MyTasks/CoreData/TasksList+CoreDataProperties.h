//
//  TasksList+CoreDataProperties.h
//  MyTasks
//
//  Created by Stas Parechyn on 16.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//
//

#import "TasksList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TasksList (CoreDataProperties)

+ (NSFetchRequest<TasksList *> *)fetchRequest;

@property (nonatomic) int16_t completionPercent;
@property (nullable, nonatomic, copy) NSDate *dueDate;
@property (nonatomic) double estimatedTime;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nonatomic) int16_t stateInt;

@end

NS_ASSUME_NONNULL_END
