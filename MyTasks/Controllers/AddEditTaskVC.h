//
//  AddEditTaskVC.h
//  MyTasks
//
//  Created by Stas Parechyn on 14.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TasksList+CoreDataProperties.h"

@interface AddEditTaskVC : UITableViewController

@property (nonatomic) TasksList *myTask;
@property BOOL editingMode;

@end
