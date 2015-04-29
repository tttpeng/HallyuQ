//
//  HQBaseBarView.m
//  HallyuQ
//
//  Created by iPeta on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQBaseBarView.h"

@interface HQBaseBarView()



@end

@implementation HQBaseBarView

+ (HQBaseBarView *)baseTabViewWithWidth:(CGFloat)width title:(NSString *)title
{
    HQBaseBarView *view = (HQBaseBarView *)[[NSBundle mainBundle] loadNibNamed:@"HQBaseBarView" owner:nil options:nil][0];
    view.width = width;
    view.titleLabel.text = title;
    return view;
}
- (IBAction)backButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(baseBarViewDidClickBackButton)]) {
        [self.delegate baseBarViewDidClickBackButton];
    }
}
@end
