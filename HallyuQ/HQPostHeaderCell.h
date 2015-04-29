//
//  HQPostHeaderCell.h
//  HallyuQ
//
//  Created by qingyun on 15/3/26.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQPostHeaderCell;
@interface HQPostHeaderCell : UITableViewCell <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *tiltlelable;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic,assign) CGFloat cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
