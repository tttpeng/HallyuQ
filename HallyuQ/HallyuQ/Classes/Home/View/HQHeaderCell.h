//
//  HQHeaderCell.h
//  HallyuQ
//
//  Created by Ace on 15/3/29.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQHeaderCell : UITableViewCell

@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *titles;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
