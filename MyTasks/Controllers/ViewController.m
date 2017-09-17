//
//  ViewController.m
//  MyTasks
//
//  Created by Stas Parechyn on 14.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import "ViewController.h"
#import "AddEditTaskVC.h"
#import "ChangeProgressController.h"
#import "CoreDataManager.h"
#import "NSDateTools.h"
#import "TaskCell.h"

@interface ViewController ()
{
    float startPoint;
    float maxPoint;
    unsigned int startSuccessPercent;
    unsigned int successPercent;
    float onePercentInPixels;
}

@property (nonatomic) TasksList *currentTask;
@property (nonatomic) NSMutableArray<NSMutableArray <TasksList *>*> *listArray;
@property (nonatomic) ChangeProgressController *changeProgressVC;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.changeProgressVC = [self.storyboard instantiateViewControllerWithIdentifier:@"changeProgressVC"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    self.tableView.tableFooterView = [UIView new];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
    [self.segmentedControl setTitle:NSLocalizedString(@"tasks", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"finished", nil) forSegmentAtIndex:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self retrieveTasks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Empty Data

- (void)addEmptyBG {
    if (self.listArray.count == 0 && self.segmentedControl.selectedSegmentIndex != 1) {
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.tableView.bounds))];
        noDataLabel.text = NSLocalizedString(@"noDataInstruction", nil);
        noDataLabel.numberOfLines = 0;
        noDataLabel.font = [UIFont systemFontOfSize:23];
        noDataLabel.textColor = RGB(60,60,60,0.7);
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        self.tableView.backgroundView = noDataLabel;
    }
    else {
        self.tableView.backgroundView = nil;
    }
}

#pragma mark - Array

- (void)removeFromListArray:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    if (self.listArray[indexPath.section].count == 1) {
        [self.listArray removeObjectAtIndex:indexPath.section];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        [self.listArray[indexPath.section] removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self.tableView endUpdates];
}

#pragma mark - CoreData

- (void)retrieveTasks {
    NSManagedObjectContext *context = CoreDataManager.shared.context;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TasksList"];
    
    //sort by deadline date
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:true];
    request.sortDescriptors = @[sortDescriptor];
    
    //Filter for "Tasks" and "Finished" TableView
    NSString *predicateString = (self.segmentedControl.selectedSegmentIndex == 1) ? @"completionPercent == 100" : @"completionPercent < 100";
    request.predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching Tasks objects: %@\n%@", error.localizedDescription, error.userInfo);
        return;
    }
    
    NSMutableArray *sortedByDate= results.mutableCopy;
    
    //When you create new task and close app, in DB left empty task, so we need to delete it
    for (TasksList *task in sortedByDate) {
        if (task.state == kTaskStateNotDefined) {
            [context deleteObject:task];
            [sortedByDate removeObject:task];
        }
    }
    
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:sortedByDate.count];
    
    //Grouping tasks by date
    while(sortedByDate.count)
    {
        TasksList *task = sortedByDate[0];
        NSPredicate *itemNamePredicate = [NSPredicate predicateWithFormat:@"(dueDate.stringFormat == %@)",task.dueDate.stringFormat];
        
        NSArray *item= [sortedByDate filteredArrayUsingPredicate: itemNamePredicate];
        
        [sortedArray addObject:item.mutableCopy];
        [sortedByDate removeObjectsInArray: item];
    }
    
    self.listArray = sortedArray;
    
    [self addEmptyBG];
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray[section].count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 50;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    header.textLabel.text = self.listArray[section][0].dueDate.stringFormat;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TasksList *task = self.listArray[indexPath.section][indexPath.row];
    
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = task.name;
    cell.detailTextLabel.text = [task stringFromEstimatedTimeInterval];
    
    if (task.completionPercent == 100) {
        cell.imageView.image = [UIImage imageNamed:@"finished"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"not_finished"];
        cell.labelOnImage.text = [NSString stringWithFormat:@"%ld",(long)task.completionPercent];
    }
    
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 0.5;
    [cell addGestureRecognizer:longPressRecognizer];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    AddEditTaskVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addEditTaskVC"];
    vc.editingMode = true;
    vc.myTask = self.listArray[indexPath.section][indexPath.row];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];;
    [self presentViewController:navVC animated:true completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [CoreDataManager.shared deleteObject:self.listArray[indexPath.section][indexPath.row]];
        [self removeFromListArray:indexPath];
    }
}

#pragma mark - Buttons

- (IBAction)addTaskAction:(id)sender {
    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addEditTaskNav"];
    [self presentViewController:navVC animated:true completion:nil];
}

#pragma mark - Segment Control

- (IBAction)handleSegmentTouch:(id)sender {
    [self retrieveTasks];
}

#pragma mark - Gesture Recognizer

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        return;
    }
  
    CGPoint location = [gesture locationInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        startPoint = location.y;
        
        //Determine the distance to which edge of the screen is closer, bottome or top
        //This is going to be maximum distance to swipe in every direction
        short screenHeight = [UIScreen mainScreen].bounds.size.height;
        maxPoint = (startPoint > screenHeight/2) ? screenHeight : 1;
        
        onePercentInPixels = (maxPoint - startPoint);
        onePercentInPixels /= (startSuccessPercent == 100) ? 100 : (100-startSuccessPercent);//checking for division by 0
        if (onePercentInPixels < 0) {
            onePercentInPixels *= (-1);
        }
        
        UITableViewCell *cell = (UITableViewCell *)gesture.view;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        self.currentTask = self.listArray[indexPath.section][indexPath.row];
        
        startSuccessPercent = self.currentTask.completionPercent;
        successPercent = startSuccessPercent;
        
        self.view.window.windowLevel = UIWindowLevelStatusBar;
        [self.navigationController.view addSubview:self.changeProgressVC.view];
        self.changeProgressVC.label.text = [NSString stringWithFormat:@"%d%%",successPercent];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        float distance = location.y - startPoint; //measure distance between startPoint and current position of our touch
        if (distance == 0) { return; }
        
        float changes = distance/onePercentInPixels;//changes from start point
        if (changes < 0) {
            changes *= (-1);
        }
        
        if (location.y < startPoint) {
            //if current position higher than start position, increase the value
            successPercent = ((startSuccessPercent+changes) >= 100) ? 100 : startSuccessPercent+changes;
        }
        else {
            //if current position lower than start position, reduce the value
            successPercent = ((startSuccessPercent-changes) <= 0) ? 0 : startSuccessPercent-changes;
        }

        self.changeProgressVC.label.text = [NSString stringWithFormat:@"%d%%",successPercent];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed
             || gesture.state == UIGestureRecognizerStateCancelled) {
        
        [self.currentTask setTaskCompletePercents:successPercent];
        
        //Perform moving to another table(deleting from this)
        TaskCell *cell = (TaskCell *)gesture.view;
        if (self.currentTask.state == kTaskStateFinished) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self removeFromListArray:indexPath];
        }
        else {
            cell.labelOnImage.text = [NSString stringWithFormat:@"%ld",(long)successPercent];
        }
        [CoreDataManager.shared save];
        
        self.view.window.windowLevel = UIWindowLevelNormal;
        [self.changeProgressVC.view removeFromSuperview];
    }
}

@end
