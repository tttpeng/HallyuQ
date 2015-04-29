//
//  HQNewsDetailHeaderView.m
//  HallyuQ
//
//  Created by Ace on 15/4/2.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQNewsDetailHeaderView.h"
#import "HQNews.h"
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "HQNewsImagesSizeTool.h"

#define kMargin 10.0f

@interface HQNewsDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *lastNewsTitle;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewsButton;
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (assign, nonatomic) int news_id;

@property (assign, nonatomic) CGFloat imageHeight;
@end

@implementation HQNewsDetailHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HQNewsDetailHeaderView" owner:nil options:nil] firstObject];
    }
    return self;
}

- (void)setNews:(HQNews *)news
{
    _news = news;
    
    self.news_id = [news.news_id intValue];
    
    self.titleLabel.text = news.titile;
    
    self.timeLabel.text = news.date;
    
    self.authorLabel.text = news.author;
    
    self.themeLabel.text = news.theme;
    
    [self.viewsButton setTitle:[NSString stringWithFormat:@" %ld", (long)news.views] forState:UIControlStateNormal];
    
    [self.newsImage sd_setImageWithURL:[NSURL URLWithString:news.image]];
    [self layoutImage:self.newsImage.image forView:self.newsImage];
    
    //设置正文内容
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:news.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [news.content length])];
    _contentLabel.attributedText = attributedString;
    
}

- (CGFloat)headerViewHeightWithNews:(HQNews *)news
{
    CGFloat headerHeight = 0.0f;
    CGFloat preferredWidth = [UIScreen mainScreen].bounds.size.width - 2 * kMargin;
    self.titleLabel.text = news.titile;
    self.titleLabel.preferredMaxLayoutWidth = preferredWidth;
    
    //设置正文内容 以及 通过内容计算正文的高度
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:news.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [news.content length])];
    
    self.contentLabel.attributedText = attributedString;
    self.contentLabel.preferredMaxLayoutWidth = preferredWidth;
    
    //计算整体的高度
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    headerHeight += size.height;
    
    return headerHeight;
}

- (CGFloat)imageHeightWithImageUrlStr:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString* pathExtension = [url.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    
    HQNewsImagesSizeTool *tool = [[HQNewsImagesSizeTool alloc] init];
    
    if ([pathExtension isEqualToString:@"gif"])
    {
        size = [tool downloadGIFImageSizeWithRequest:request];
    }
    else if([pathExtension isEqualToString:@"png"])
    {
        size = [tool downloadPNGImageSizeWithRequest:request];
    }
    else
    {
        size = [tool downloadJPGImageSizeWithRequest:request];
    }
    
    CGFloat rate = size.height / size.width;
    
    CGFloat imageHeight = (self.width - 2 * kMargin) * rate;
    
    return imageHeight;
}


//添加NewsImageView的高的约束
-(void)layoutImage:(UIImage *)image forView:(UIView *)view{
    CGFloat imageHeight = [self imageHeightWithImageUrlStr:self.news.image];
    for (NSLayoutConstraint *constraint in view.constraints) {
        if(constraint.firstAttribute == NSLayoutAttributeHeight){
            constraint.constant = imageHeight;
        }
    }
}

@end
