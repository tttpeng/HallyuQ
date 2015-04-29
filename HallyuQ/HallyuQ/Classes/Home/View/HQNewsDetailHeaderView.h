//
//  HQNewsDetailHeaderView.h
//  HallyuQ
//
//  Created by Ace on 15/4/2.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HQNews;

@interface HQNewsDetailHeaderView : UIView

@property (strong, nonatomic) HQNews *news;

- (CGFloat)headerViewHeightWithNews:(HQNews *)news;

@end
