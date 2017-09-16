//
//  DateFieldTextField.h
//  MyTasks
//
//  Created by Stas Parechyn on 14.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateFieldTextFieldDelegate <NSObject>

- (void)didSelectDate:(NSDate *)date andTimeInterval:(NSTimeInterval)interval;

@end

@interface DateFieldTextField : UITextField

@property (nonatomic) UIDatePicker *datePicker;
@property (nonatomic, weak) id <DateFieldTextFieldDelegate> dateDelegate;

@end
