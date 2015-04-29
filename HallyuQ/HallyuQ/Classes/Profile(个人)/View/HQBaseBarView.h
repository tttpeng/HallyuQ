//
//  HQBaseBarView.h
//  HallyuQ
//
//  Created by iPeta on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQBaseBarViewDelegate <NSObject>

@optional
- (void)baseBarViewDidClickBackButton;

@end

@interface HQBaseBarView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+ (HQBaseBarView *)baseTabViewWithWidth:(CGFloat)width title:(NSString *)title;
@property (nonatomic, weak) id<HQBaseBarViewDelegate>delegate;

@end
