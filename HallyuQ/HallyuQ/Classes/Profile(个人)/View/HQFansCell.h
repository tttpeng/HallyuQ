//
//  HQFansCell.h
//  HallyuQ
//
//  Created by iPeta on 15/4/2.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQUser;
@interface HQFansCell : UITableViewCell

@property (nonatomic ,strong)HQUser *user;

+ (instancetype)cellWithTableview:(UITableView *)tableView;

@end
