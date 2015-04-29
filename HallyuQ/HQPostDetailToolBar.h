//
//  HQPostDetailToolBar.h
//  HallyuQ
//
//  Created by qingyun on 15/3/30.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQPostDetailToolBar;
@protocol HQPostDetailToolBar <NSObject>

@optional
- (void)toolbar:(HQPostDetailToolBar *)toolbar didClickedButton:(UIButton *)button;

@end
@interface HQPostDetailToolBar : UIView
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UITextField *commentText;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;

@property (nonatomic,weak) id<HQPostDetailToolBar> delegate;

@end
