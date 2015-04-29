//
//  HQAddFansViewController.h
//  HallyuQ
//
//  Created by iPeta on 15/4/2.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQUser;
@interface HQAddFansViewController : UIViewController

/**
 *  你想查看的用户的用户模型
 */
@property (nonatomic,strong)HQUser *user;
@end
