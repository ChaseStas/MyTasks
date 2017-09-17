//
//  CoreDataManager.m
//  MyTasks
//
//  Created by Stas Parechyn on 14.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

+ (CoreDataManager *)shared {
    static dispatch_once_t onceToken;
    static id coreDataManager;
    dispatch_once(&onceToken, ^{
        coreDataManager = [[CoreDataManager alloc] init];
    });
    
    return coreDataManager;
}

- (NSManagedObjectContext *)context {
    return ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
}

- (void)save {
    NSManagedObjectContext *context = self.context;
    NSError *error = nil;
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

- (void)deleteObject:(NSManagedObject *)object {
    [self.context deleteObject:object];
    [self save];
}

@end
