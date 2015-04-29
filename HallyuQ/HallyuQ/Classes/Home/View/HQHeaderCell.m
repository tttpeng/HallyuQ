//
//  HQHeaderCell.m
//  HallyuQ
//
//  Created by Ace on 15/3/29.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQHeaderCell.h"
#import <UIImageView+WebCache.h>

#define kImageViewH (kScreenWidth / 16) * 9
#define kMargin 10.0f
#define kLabelH 10.0f

@interface HQHeaderCell () <UIScrollViewDelegate>

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation HQHeaderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"HeaderCell";
    HQHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HQHeaderCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    //添加滚动视图
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * (images.count + 2), self.height);
    self.scrollView.pagingEnabled = YES;//翻页滚动
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;//水平方向拉条隐藏
    self.scrollView.bounces = NO;//取消拖拽的时候的回弹效果
    
    UIImageView *firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kImageViewH)];
    [firstImageView sd_setImageWithURL:[NSURL URLWithString:[images lastObject]]];
    [self.scrollView addSubview:firstImageView];
    
    UIImageView *lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * (images.count + 1), 0, kScreenWidth, kImageViewH)];
    [lastImageView sd_setImageWithURL:[NSURL URLWithString:[images firstObject]]];
    [self.scrollView addSubview:lastImageView];
    
    for (int i = 0; i < images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * (i + 1), 0, kScreenWidth, kImageViewH)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]]];
        [self.scrollView addSubview:imageView];
    }
    
    [self addTimer];
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    self.titleLabel.text = [NSString stringWithFormat:@"#%@#", [self.titles lastObject]];
}

- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrollViewBeginScroll) userInfo:nil repeats:YES];
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewBeginScroll
{
    CGFloat currentOffsetX = self.scrollView.contentOffset.x;
    NSInteger page = currentOffsetX / kScreenWidth;
    if (page == self.images.count + 1) {
        
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
        [self scrollViewBeginScroll];
        
        return;
    }else
    {
        page ++;
    }
    
    CGFloat offsetX = self.scrollView.width * page;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    self.pageCtrl.currentPage = (int)(page + 0.5) - 1;
    if (page == (self.images.count + 1)) {
        self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        self.pageCtrl.currentPage = 0;
    }
    else if (page == 0) {
        self.scrollView.contentOffset = CGPointMake(self.images.count * kScreenWidth, 0);
        self.pageCtrl.currentPage = self.images.count - 1;
    }
    
    //动态显示titleLabel的内容
    switch ((int)page) {
        case 0:
            self.titleLabel.text = [NSString stringWithFormat:@"#%@#", [self.titles lastObject]];
            break;
        case 1:
            self.titleLabel.text = [NSString stringWithFormat:@"#%@#", self.titles[0]];
            break;
        case 2:
            self.titleLabel.text = [NSString stringWithFormat:@"#%@#", self.titles[1]];
            break;
        case 3:
            self.titleLabel.text = [NSString stringWithFormat:@"#%@#", self.titles[2]];
            break;
        case 4:
            self.titleLabel.text = [NSString stringWithFormat:@"#%@#", [self.titles firstObject]];
            break;
        default:
            break;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
@end
