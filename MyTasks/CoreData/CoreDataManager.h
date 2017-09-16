//
//  CoreDataManager.h
//  MyTasks
//
//  Created by Stas Parechyn on 14.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface CoreDataManager : NSObject

- (void)save;
- (void)deleteObject:(NSManagedObject *)object;
- (NSManagedObjectContext *)context;

+ (CoreDataManager *)shared;
@end
