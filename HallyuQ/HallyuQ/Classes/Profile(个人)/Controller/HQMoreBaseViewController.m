//
//  HQMoreBaseViewController.m
//  HallyuQ
//
//  Created by iPeta on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQMoreBaseViewController.h"
#import "HQBaseBarView.h"

@interface HQMoreBaseViewController ()<HQBaseBarViewDelegate>

@end

@implementation HQMoreBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    HQBaseBarView *barView = [HQBaseBarView baseTabViewWithWidth:[UIScreen mainScreen].bounds.size.width title:self.title];
    barView.delegate = self;
    self.barView = barView;
    [self.view addSubview:barView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)baseBarViewDidClickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
