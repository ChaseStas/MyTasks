//
//  TextFieldCell.m
//  MyTasks
//
//  Created by Stas Parechyn on 14.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.charactersLimit = 0;
    self.textField.delegate = self;
    self.textField.placeholder = NSLocalizedString(@"taskPlaceholder", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.charactersLimit != 0) {
        if (textField.text.length < self.charactersLimit || string.length == 0){
            
            //Protect our TextField from "paste" big string
            if (![string isEqualToString:@""] && textField.text.length + string.length >= self.charactersLimit) {
                NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
                textField.text = [str substringToIndex:self.charactersLimit];
                return false;
            }
            return true;
        }
        else{
            return false;
        }
    }
    return true;
}


@end
