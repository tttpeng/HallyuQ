//
//  HQPostDetailCell.h
//  HallyuQ
//
//  Created by qingyun on 15/3/28.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
@class HQComment;
@interface HQPostDetailCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *userName;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) HQComment *comment;
+(instancetype)cellWithTableView:(UITableView *)tableView;

-(CGFloat)cellHeightWithComment:(HQComment *)comment;
@end
