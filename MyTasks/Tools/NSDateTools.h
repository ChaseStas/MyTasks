//
//  NSDateTools.h
//  MyTasks
//
//  Created by Stas Parechyn on 15.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (Tools)

@property (nonatomic, readonly) NSInteger hours;
@property (nonatomic, readonly) NSInteger minutes;
@property (nonatomic, readonly, copy) NSString *stringFormat;

@end
