//
//  HQNavigationViewController.m
//  HallyuQ
//
//  Created by iPeta on 15/3/19.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQNavigationViewController.h"
#import "HQAddFansViewController.h"

@interface HQNavigationViewController ()

@end

@implementation HQNavigationViewController


+ (void)initialize
{   UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    bar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [bar setTitleTextAttributes:attrs];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[HQAddFansViewController class]]) {
        viewController.hidesBottomBarWhenPushed = NO;
    }else
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
