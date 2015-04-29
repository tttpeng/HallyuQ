//
//  HQNewsDetailCell.h
//  HallyuQ
//
//  Created by Ace on 15/4/2.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQNewsComment;
@interface HQNewsCommentCell : UITableViewCell

@property (strong, nonatomic) HQNewsComment *newsComment;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)cellHeightWithComment:(HQNewsComment *)newsComment;

@end
