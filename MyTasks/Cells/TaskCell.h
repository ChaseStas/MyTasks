//
//  TaskCell.h
//  MyTasks
//
//  Created by Stas Parechyn on 16.09.17.
//  Copyright © 2017 Stas Parechyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelOnImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *detailTextLabel;

@end
