//
//  ZYThemeNavViewController.h
//  HallyuQ
//
//  Created by Ace on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThemeBar;
@interface ZYThemeNavViewController : UIViewController

@property (strong, nonatomic) NSArray *subViewControllers;


/**
 *  Initialize ZYThemeNavViewController Instance And Show Children View Controllers
 *
 *  @param subViewControllers - set an array of children view controllers
 *
 *  @return Instance
 */
- (id)initWithSubViewControllers:(NSArray *)subViewControllers;


/**
 *  Initialize ZYThemeNavViewController Instance And Show On The Parent View Controller
 *
 *  @param viewController - set parent view controller
 *
 *  @return Instance
 */
- (id)initWithParentViewController:(UIViewController *)viewController;


/**
 *  Initialize ZYThemeNavViewController Instance, Show On The Parent View Controller And Show On The Parent View Controller
 *
 *  @param subControllers - set an array of children view controllers
 *  @param viewController - set parent view controller
 *  @param show           - is show the arrow button
 *
 *  @return Instance
 */
- (id)initWithSubViewControllers:(NSArray *)subControllers andParentViewController:(UIViewController *)viewController;

/**
 *  Show On The Parent View Controller
 *
 *  @param viewController - set parent view controller
 */
- (void)addParentController:(UIViewController *)viewController;


@end
