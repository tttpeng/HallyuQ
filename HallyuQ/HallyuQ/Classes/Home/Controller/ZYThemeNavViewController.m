//
//  ZYThemeNavViewController.m
//  HallyuQ
//
//  Created by Ace on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "ZYThemeNavViewController.h"
#import "ThemeBar.h"


#define kScrollViewMargin 20.0f

@interface ZYThemeNavViewController () <UIScrollViewDelegate, ThemeBarDelegate>
{
    NSInteger _currentIndex;
    NSMutableArray *_titles;
    
    ThemeBar *_themeBar;
    UIScrollView *_mainView;
}

@end

@implementation ZYThemeNavViewController

- (id)initWithSubViewControllers:(NSArray *)subViewControllers
{
    self = [super init];
    if (self) {
        _subViewControllers = subViewControllers;
    }
    return self;
}

- (id)initWithParentViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        [self addParentController:viewController];
    }
    return self;
}

- (id)initWithSubViewControllers:(NSArray *)subControllers andParentViewController:(UIViewController *)viewController
{
    self = [self initWithSubViewControllers:subControllers];
    [self addParentController:viewController];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
    
    [self viewConfig];
    
    [self.tabBarController.tabBar setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark -
#pragma mark - Private Methods
- (void)initConfig
{
    _currentIndex = 1;
    
    _titles = [[NSMutableArray alloc] initWithCapacity:_subViewControllers.count];
    for (UIViewController *viewController in _subViewControllers) {
        [_titles addObject:viewController.title];
    }
}

- (void)viewInit
{
    _themeBar = [[ThemeBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
    _themeBar.delegate = self;
    _themeBar.backgroundColor = [UIColor whiteColor];
    _themeBar.itemTitles = _titles;
    [_themeBar updateData];
    
    CGFloat mainViewY = _themeBar.frame.origin.y + _themeBar.frame.size.height;
    CGFloat mainViewH = kScreenHeight - _themeBar.frame.origin.y - _themeBar.frame.size.height - kStatusBarHeight - kNavigationBarHeight;
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, mainViewY, kScreenWidth, mainViewH)];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = NO;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.contentSize = CGSizeMake(kScreenWidth * _subViewControllers.count, 0);
    [self.view addSubview:_mainView];
    [self.view addSubview:_themeBar];
    
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, -64, 375, 64);
    view.backgroundColor = [UIColor colorWithRed:0.901 green:0.201 blue:0.413 alpha:1.000];
    [self.view addSubview:view];
}

- (void)viewConfig
{
    [self viewInit];
    
    
    [_subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        UIViewController *viewController = (UIViewController *)_subViewControllers[idx];
        viewController.view.frame = CGRectMake(idx * kScreenWidth, 0, kScreenWidth, _mainView.frame.size.height);
        [_mainView addSubview:viewController.view];
        [self addChildViewController:viewController];
        
    }];
}
#pragma mark -
#pragma mark - Public Methods

- (void)addParentController:(UIViewController *)viewController
{
    if ([viewController respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
}

#pragma mark -
#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x / kScreenWidth + 0.5;
    _themeBar.currentItemIndex = _currentIndex;
}

#pragma mark -
#pragma mark - ThemeBarDelegate Methods
- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    [_mainView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:NO];
}

@end
