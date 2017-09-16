//
//  TasksList+CoreDataProperties.m
//  MyTasks
//
//  Created by Stas Parechyn on 16.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//
//

#import "TasksList+CoreDataProperties.h"

@implementation TasksList (CoreDataProperties)

+ (NSFetchRequest<TasksList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TasksList"];
}

@dynamic completionPercent;
@dynamic dueDate;
@dynamic estimatedTime;
@dynamic name;
@dynamic startDate;
@dynamic stateInt;

@end
