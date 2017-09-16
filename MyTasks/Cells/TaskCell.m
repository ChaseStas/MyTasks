//
//  TaskCell.m
//  MyTasks
//
//  Created by Stas Parechyn on 16.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell
@synthesize textLabel;
@synthesize detailTextLabel;
@synthesize imageView;

- (void)prepareForReuse {
    [super prepareForReuse];
    self.labelOnImage.text = @"";
}

@end
