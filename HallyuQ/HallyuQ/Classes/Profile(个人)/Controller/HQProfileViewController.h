//
//  HQProfileViewController.h
//  HallyuQ
//
//  Created by iPeta on 15/3/19.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQUser;
@class HQProfileViewController;

@protocol HQProfileViewcontrollerDelegate <NSObject>

@optional
- (void)profileViewContorllerDidReloadDataWithType:(accountTabViewButtonType)type;

@end

@interface HQProfileViewController : UIViewController

@property (nonatomic, strong)HQUser *user;


@property (nonatomic, weak) id<HQProfileViewcontrollerDelegate> delegate;
@end
