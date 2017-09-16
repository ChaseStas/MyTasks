//
//  DateFieldTextField.m
//  MyTasks
//
//  Created by Stas Parechyn on 14.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import "DateFieldTextField.h"
#import "NSDateTools.h"

@implementation DateFieldTextField
- (void)awakeFromNib {
    [super awakeFromNib];
    self.datePicker = [[UIDatePicker alloc] init];
    [self.datePicker addTarget:self action:@selector(dateHasBeenChanged) forControlEvents:UIControlEventValueChanged];
    
    self.inputAccessoryView = [self configureToolBar];
    self.inputView = self.datePicker;
}

#pragma mark - Toolbar
- (UIToolbar *)configureToolBar {
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(toolBarDoneButton)];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    toolbar.userInteractionEnabled = true;
    [toolbar sizeToFit];
    return toolbar;
}

- (void)toolBarDoneButton {
    if (self.dateDelegate != nil) {
        [self dateHasBeenChanged];
    }
    [self endEditing:true];
    [self resignFirstResponder];
}

#pragma mark - Date Picker
- (void)dateHasBeenChanged{
    if ([self.dateDelegate respondsToSelector:@selector(didSelectDate:andTimeInterval:)]) {
        [self.dateDelegate didSelectDate:self.datePicker.date andTimeInterval:self.datePicker.countDownDuration];
    }
}

//Removing curcos from TextField
- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return CGRectZero;
}
@end
