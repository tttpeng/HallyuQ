//
//  HQSendToolBar.h
//  HallyuQ
//
//  Created by qingyun on 15/3/25.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HQSendToolBar;
@protocol HQSendToolBarDelegate <NSObject>

- (void)toolBar:(HQSendToolBar *)toolbar didClickedButton:(UIButton *)button;

@end

@interface HQSendToolBar : UIView

@property (weak, nonatomic) IBOutlet UIButton *emoBUtton;
@property (weak, nonatomic) IBOutlet UIButton *recButton;

@property (weak, nonatomic) IBOutlet UIButton *picButton;

@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (nonatomic,weak) id<HQSendToolBarDelegate> delegate;

@end
