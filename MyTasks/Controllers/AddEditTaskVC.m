//
//  AddEditTaskVC.m
//  MyTasks
//
//  Created by Stas Parechyn on 14.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import "AddEditTaskVC.h"
#import "TextFieldCell.h"
#import "DateTextFieldCell.h"
#import "CoreDataManager.h"
#import "NSDateTools.h"

@interface AddEditTaskVC () <DateFieldTextFieldDelegate, UITextFieldDelegate>
{
    BOOL firstResponderOnStart;
}
@property (nonatomic) UITextField *currentTextField;
@end

@implementation AddEditTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.editingMode ? @"" : NSLocalizedString(@"newtask", nil);
    firstResponderOnStart = true;
    
    if (!self.editingMode) {
        NSManagedObjectContext *context = CoreDataManager.shared.context;
        self.myTask = [NSEntityDescription insertNewObjectForEntityForName:@"TasksList"
                                                    inManagedObjectContext:context];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        if (firstResponderOnStart) {
            [cell.textField becomeFirstResponder];
            firstResponderOnStart = false;
        }
        
        if (self.myTask.name.length > 0) {
            cell.textField.text = self.myTask.name;
        }
        return cell;
    }
    else {
        DateTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dateCell" forIndexPath:indexPath];
        cell.label.text = (indexPath.section == 1) ? NSLocalizedString(@"deadline", nil) : NSLocalizedString(@"estimatedtime", nil);
        
        cell.textField.dateDelegate = self;
        cell.textField.delegate = self;
        
        UIDatePicker *picker = cell.textField.datePicker;
        if (indexPath.section == 2) {
            picker.datePickerMode = UIDatePickerModeTime;
            [picker setLocale:[NSLocale localeWithLocaleIdentifier:@"nl_NL"]]; //So DatePicker going to be in 24H mode on every device
            picker.date = self.myTask.estimatedTimeDate;
            cell.textField.text = self.myTask.stringFromEstimatedTimeInterval;
        }
        else {
            picker.datePickerMode = UIDatePickerModeDate;
            picker.minimumDate = self.myTask.startDate;
            picker.date = self.myTask.dueDate;
            cell.textField.text = [self.myTask.dueDate stringFormat];
        }
        
        cell.textField.tag = indexPath.section;
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        DateTextFieldCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
        self.currentTextField = cell.textField;
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
}

#pragma mark - UIDatePickerDelegate

- (void)didSelectDate:(NSDate *)date andTimeInterval:(NSTimeInterval)interval {
    if (self.currentTextField != nil) {
        if (self.currentTextField.tag == 2) {
            self.myTask.estimatedTime = interval;
            self.currentTextField.text = self.myTask.stringFromEstimatedTimeInterval;
        }
        else {
            self.myTask.dueDate = date;
            self.currentTextField.text = [date stringFormat];
        }
    }
}

#pragma mark - UITextField

- (void)textFieldDidChange:(UITextField *)textField {
    self.myTask.name = textField.text;
}

#pragma mark - Buttons

- (IBAction)handleDoneButton:(id)sender {
    if (!self.editingMode) {
        if (self.myTask.name.length == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"oops", nil) message:NSLocalizedString(@"entertitle", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okayAction];
            [self presentViewController:alertController animated:true completion:nil];
            return;
        }
        
        self.myTask.state = kTaskStateNew;
    }
    [CoreDataManager.shared save];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)handleCancelButton:(id)sender {
    if (!self.editingMode) {
        [CoreDataManager.shared deleteObject:self.myTask];
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
