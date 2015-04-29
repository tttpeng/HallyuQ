//
//  HQPerDataCell.h
//  HallyuQ
//
//  Created by iPeta on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQUser;
@interface HQPerDataCell : UITableViewCell

@property (nonatomic, strong)HQUser *user;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
