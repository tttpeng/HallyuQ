//
//  HQHomeHeaderCell.m
//  HallyuQ
//
//  Created by Ace on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQHomeHeaderCell.h"
#import "HQNews.h"
#import <UIImageView+WebCache.h>


@interface HQHomeHeaderCell()

@property (weak, nonatomic) IBOutlet UIImageView *focusView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewsButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HQHomeHeaderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"ID";
    HQHomeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HQHomeHeaderCell" owner:nil options:nil] firstObject];
    }
    
    return cell;
}


- (void)setNews:(HQNews *)news
{
    _news = news;
    
    self.focusView.contentMode = UIViewContentModeScaleAspectFill;
    self.focusView.clipsToBounds = YES;
    [self.focusView sd_setImageWithURL:[NSURL URLWithString:news.image]];
    
    self.titleLabel.text = news.titile;
    
    self.timeLabel.text = news.date;
    
    self.authorLabel.text = news.author;
    
    self.themeLabel.text = news.theme;
    
    [self.viewsButton setTitle:[NSString stringWithFormat:@" %ld", (long)news.views] forState:UIControlStateNormal];
    
    
    //设置正文内容
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:news.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [news.content length])];
    _contentLabel.attributedText = attributedString;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}



@end
