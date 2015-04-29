//
//  HQHomeViewController.m
//  HallyuQ
//
//  Created by iPeta on 15/3/19.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQHomeViewController.h"
#import "ThemeBar.h"
#import "ZYHomeViewController.h"
#import "ZYStarViewController.h"
#import "ZYMovieViewController.h"
#import "ZYArtsViewController.h"
#import "ZYMusicViewController.h"
#import "ZYThemeNavViewController.h"

@interface HQHomeViewController ()

@end

@implementation HQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftButton_Nav"] style:UIBarButtonItemStylePlain target:self action:@selector(moreGong)];
    self.navigationItem.leftBarButtonItem = leftItem;

    
    [self setViewControllers];

}

- (void)setViewControllers
{
    ZYHomeViewController *home = [[ZYHomeViewController alloc] init];
    home.title = @"首页";
    
    ZYStarViewController *star = [[ZYStarViewController alloc] init];
    star.title = @"明星";
    
    ZYMovieViewController *movie = [[ZYMovieViewController alloc] init];
    movie.title = @"韩剧";
    
    ZYArtsViewController *arts = [[ZYArtsViewController alloc] init];
    arts.title = @"综艺";
    
    ZYMusicViewController *music = [[ZYMusicViewController alloc] init];
    music.title = @"音乐";
    
    
    ZYThemeNavViewController *nav = [[ZYThemeNavViewController alloc] init];
    nav.subViewControllers = @[home, star, movie, arts, music];
    [nav addParentController:self];
}

- (void)moreGong
{
    NSLog(@"LEFT Button");
}

@end
