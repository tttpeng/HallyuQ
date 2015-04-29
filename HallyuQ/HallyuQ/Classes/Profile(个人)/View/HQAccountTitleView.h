//
//  HQAccountTitleView.h
//  HallyuQ
//
//  Created by iPeta on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    accountTitleViewButtonTypeEdit,
    accountTitleViewButtonTypeSetting,
    accountTitleViewButtonTypeFans,
    accountTitleViewButtonTypeFollow

}accountTitleViewButtonType;

@class HQAccountTitleView;
@class HQUser;

@protocol HQAccountTitleViewDelegate <NSObject>

- (void)accountTitleView:(HQAccountTitleView *)titleView DidClickTitleBtn:(accountTitleViewButtonType)buttonIndex;

@end

@interface HQAccountTitleView : UIView

@property (nonatomic,strong)HQUser *user;
+ (HQAccountTitleView *)instanceWithFrame:(CGRect)frame;
@property (nonatomic, weak) id<HQAccountTitleViewDelegate>delegate;
@end
