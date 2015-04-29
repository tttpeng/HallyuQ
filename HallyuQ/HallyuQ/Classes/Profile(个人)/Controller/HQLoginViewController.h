//
//  HQLoginViewController.h
//  HallyuQ
//
//  Created by iPeta on 15/3/26.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQUser;

@protocol HQLoginViewControllerDelegate <NSObject>

@optional
- (void)loginViewControllerDidLoginSuccessWithUser:(HQUser*)user;

@end
@interface HQLoginViewController : UIViewController
@property (nonatomic, weak) id<HQLoginViewControllerDelegate>delegate;
@end
