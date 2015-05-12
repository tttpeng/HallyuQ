//
//  HQPostDetailToolBar.m
//  HallyuQ
//
//  Created by qingyun on 15/3/30.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQPostDetailToolBar.h"

@implementation HQPostDetailToolBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"HQPostDetailToolBar" owner:nil options:nil][0];
    }
    return self;
}
- (IBAction)buttonClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(toolbar:didClickedButton:)]) {
        [self.delegate toolbar:self didClickedButton:sender];
    }
}

@end
