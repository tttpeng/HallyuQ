//
//  HQTabbarViewController.m
//  HallyuQ
//
//  Created by iPeta on 15/3/19.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQTabbarViewController.h"
#import "HQHomeViewController.h"
#import "HQBBSViewController.h"
#import "HQProfileViewController.h"
#import "HQNavigationViewController.h"
#import "HQLoginViewController.h"
#import "HQUser.h"

@interface HQTabbarViewController ()<UITabBarControllerDelegate,HQLoginViewControllerDelegate>

@end

@implementation HQTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBar.tintColor = [UIColor colorWithRed:0.837 green:0.279 blue:0.444 alpha:1.000];
    HQHomeViewController *home = [[HQHomeViewController alloc] init];
    [self addChildVC:home title:@"韩流Square" barTitle:@"广场" image:@"tab_square"];

    HQBBSViewController *bbs = [[HQBBSViewController alloc] init];
    [self addChildVC:bbs title:@"饭语" barTitle:@"八卦" image:@"tab_bagua"];
    
    HQProfileViewController *profile = [[HQProfileViewController alloc] init];
    [self addChildVC:profile title:@"登录" barTitle:@"我的" image:@"tab_me"];

    self.delegate = self;
}


- (void)addChildVC:(UIViewController *)childVc title:(NSString *)title barTitle:(NSString *)barTitle image:(NSString *)image
{
    childVc.title = title;
    childVc.tabBarItem.title = barTitle;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    HQNavigationViewController *nav = [[HQNavigationViewController alloc] init];;
    [nav setViewControllers:@[childVc]];
    [self addChildViewController:nav];
    
}


- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    self.tabBar.hidden = NO;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    HQNavigationViewController *nav = (HQNavigationViewController *)viewController;
    UIViewController *viewC= nav.viewControllers[0];
    if ([viewC isKindOfClass:[HQProfileViewController class]]&&![HQUser currentUser ]) {
        HQNavigationViewController *navLogin = [[HQNavigationViewController alloc] init];
        HQLoginViewController *loginVc = [[HQLoginViewController alloc] initWithNibName:@"HQLoginViewController" bundle:nil];
        loginVc.delegate = self;
        navLogin.viewControllers = @[loginVc];
        [self presentViewController:navLogin animated:YES completion:nil];
        return NO;
    }


    return YES;
}

- (void)loginViewControllerDidLoginSuccessWithUser:(HQUser *)user
{
    self.selectedIndex = 2;
    HQProfileViewController *pro = self.selectedViewController.childViewControllers[0];
    pro.user = user;
}

@end
