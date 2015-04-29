//
//  HQPostHeaderCell.m
//  HallyuQ
//
//  Created by qingyun on 15/3/26.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQPostHeaderCell.h"

@interface HQPostHeaderCell()<UIScrollViewDelegate>

@property (nonatomic,strong) NSTimer *timer;

@end
@implementation HQPostHeaderCell

- (void)awakeFromNib {
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"postHeaderCell";
    HQPostHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HQPostHeaderCell alloc] init];
       cell = [[NSBundle mainBundle] loadNibNamed:@"HQPostHeaderCell" owner:nil options:nil][0];
    }
    return cell;
}

-(CGFloat)cellHeight
{
    CGFloat cellHeight = 0;
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = self.tiltlelable.font;
    CGSize titlesize = [self.tiltlelable.text sizeWithAttributes:attri];
    cellHeight += titlesize.height;
    CGFloat scrollheight = self.width *9/16;
    cellHeight += scrollheight;
    return cellHeight + 40;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    NSInteger count = 5;
    CGFloat imageW = self.width;
    CGFloat imageH = self.height;
    _scrollView.contentSize = CGSizeMake(imageW*count, 0);
    _scrollView.delegate = self;
    for (int i = 0;i <count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(imageW * i , 0, imageW, imageH);
        if (i == 0) {
            NSString *imageName = [NSString stringWithFormat:@"img_0%d",i+3];
            imageView.image = [UIImage imageNamed:imageName];

        }else if(i == 4)
        {
           NSString *imageName = [NSString stringWithFormat:@"img_0%d",i-3];
            imageView.image = [UIImage imageNamed:imageName];

        }else
        {
           NSString *imageName = [NSString stringWithFormat:@"img_0%d",i];
            imageView.image = [UIImage imageNamed:imageName];
        }
       [_scrollView addSubview:imageView];
    }
    self.pageControl.currentPage = 2;
    [_scrollView setContentOffset:CGPointMake(self.width*3, 0) animated:NO];
    [self addTimer];
    
    
}

- (void)addTimer
{
   _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)nextImage
{
    NSInteger page = self.scrollView.contentOffset.x / self.width;
    if (page == 4) {
        [_scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
        [self nextImage];
    }else{
        page += 1;
    }
    CGFloat offsetX = page *self.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / self.width;
    self.pageControl.currentPage = page - 1;
    if (page == 4) {
        [self.scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
        self.pageControl.currentPage = 0;
    }
    if (page == 0) {
        [_scrollView setContentOffset:CGPointMake(self.width * 3, 0) animated:YES];
        self.pageControl.currentPage = 2;
    };
    switch (page) {
        case 0:
            self.tiltlelable.text = @"#韩国整容，你值得拥有#";
            break;
        case 1:
            self.tiltlelable.text = @"#韩国明星，值得你期待#";
            break;
        case 2:
            self.tiltlelable.text = @"#韩国美女，来吧，come on#";
            break;
        case 3:
            self.tiltlelable.text = @"#韩国整容，你值得拥有#";
            break;
        case 4:
            self.tiltlelable.text = @"#韩国明星，值得你期待#";
            break;
        default:
            break;
    }
    
   

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

@end
