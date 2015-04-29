//
//  HQNewsDetailToolBar.h
//  HallyuQ
//
//  Created by Ace on 15/3/31.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    HQNewsDetailToolBarButtonBack,      //返回
    HQNewsDetailToolBarButtonFavour,    //点赞
    HQNewsDetailToolBarButtonShare,     //分享
    HQNewsDetailToolBarButtonComment    //评论
    
} HQNewsDetailToolBarButtonType;

//定义一个协议
@class HQNewsDetailToolBar;
@protocol HQNewsDetailToolbarDelegate <NSObject>

@optional

- (void)clickedButton:(HQNewsDetailToolBarButtonType)buttonType;

@end


@interface HQNewsDetailToolBar : UIView

@property (nonatomic, weak) id<HQNewsDetailToolbarDelegate> delegate;

@end
