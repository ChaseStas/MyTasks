//
//  ChangeProgressController.m
//  MyTasks
//
//  Created by Stas Parechyn on 15.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import "ChangeProgressController.h"

@interface ChangeProgressController ()
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@end

@implementation ChangeProgressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.instructionLabel.text = NSLocalizedString(@"changeProgressInstruction", nil);
}

@end
