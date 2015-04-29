//
//  HQEditingViewController.m
//  HallyuQ
//
//  Created by iPeta on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQEditingViewController.h"
#import "HQBaseBarView.h"

@interface HQEditingViewController ()<HQBaseBarViewDelegate>

@end

@implementation HQEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.barView.titleLabel.text = @"我的资料";
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)baseBarViewDidClickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
