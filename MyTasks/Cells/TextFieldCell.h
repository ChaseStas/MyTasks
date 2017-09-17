//
//  TextFieldCell.h
//  MyTasks
//
//  Created by Stas Parechyn on 14.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell <UITextFieldDelegate>

@property NSInteger charactersLimit;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end
