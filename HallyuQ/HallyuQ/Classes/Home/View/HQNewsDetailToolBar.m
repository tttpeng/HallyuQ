//
//  HQNewsDetailToolBar.m
//  HallyuQ
//
//  Created by Ace on 15/3/31.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQNewsDetailToolBar.h"

@implementation HQNewsDetailToolBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HQNewsDetailToolBar" owner:nil options:nil] firstObject];
    }
    return self;
}

- (IBAction)back:(id)sender {
    [self.delegate clickedButton:HQNewsDetailToolBarButtonBack];
}

- (IBAction)favour:(UIButton *)button {
    [self.delegate clickedButton:HQNewsDetailToolBarButtonFavour];
    button.selected = !button.selected;
}

- (IBAction)share:(id)sender {
    [self.delegate clickedButton:HQNewsDetailToolBarButtonShare];
}

- (IBAction)comment:(id)sender {
    [self.delegate clickedButton:HQNewsDetailToolBarButtonComment];
}

@end
