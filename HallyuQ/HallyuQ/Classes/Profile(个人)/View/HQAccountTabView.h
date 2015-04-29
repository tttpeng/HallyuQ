//
//  HQAccountTabView.h
//  HallyuQ
//
//  Created by iPeta on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQProfileViewController.h"


@protocol HQAccountTabViewDelegate <NSObject>

@optional
- (void)accountTabViewButtonClickWithType:(accountTabViewButtonType)type;

@end
@interface HQAccountTabView : UIView <HQProfileViewcontrollerDelegate>
+ (HQAccountTabView *)instanceWithFrame:(CGRect)frame withType:(accountTabViewButtonType)type;
@property (nonatomic, weak) id<HQAccountTabViewDelegate>delegate;

@end
