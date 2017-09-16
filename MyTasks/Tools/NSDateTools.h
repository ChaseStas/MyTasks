//
//  NSDateTools.h
//  MyTasks
//
//  Created by Stas Parechyn on 15.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (Tools)
- (NSInteger )hours;
- (NSInteger )minutes;

- (NSString *)stringFormat;
@end
