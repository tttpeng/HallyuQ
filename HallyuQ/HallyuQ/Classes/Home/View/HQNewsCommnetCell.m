//
//  HQNewsDetailCell.m
//  HallyuQ
//
//  Created by Ace on 15/4/2.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQNewsCommentCell.h"
#import <UIImageView+WebCache.h>
#import "HQNewsComment.h"

#define kMargin 20.0f

@interface HQNewsCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attitudeNum;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (assign, nonatomic) int currentAttitude;

@end

@implementation HQNewsCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CommentCell";
    HQNewsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HQNewsCommentCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setNewsComment:(HQNewsComment *)newsComment
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:newsComment.avatar_img]];
    self.nameLabel.text = newsComment.usr_name;
    self.attitudeNum.text = [NSString stringWithFormat:@"%d", newsComment.attitude_count];
    self.timeLabel.text = newsComment.date;
    
    //设置正文内容
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:newsComment.content_text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [newsComment.content_text length])];
    
    self.contentLabel.attributedText = attributedString;
    
}

- (CGFloat)cellHeightWithComment:(HQNewsComment *)newsComment
{
    CGFloat cellHeight = 0.0f;
    CGFloat preferredWidth = [UIScreen mainScreen].bounds.size.width - 2 * kMargin;
    
    //设置正文内容 以及 通过内容计算正文的高度
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:newsComment.content_text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [newsComment.content_text length])];
    
    self.contentLabel.attributedText = attributedString;
    self.contentLabel.preferredMaxLayoutWidth = preferredWidth;
    
    
    //计算整体的高度
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    cellHeight += size.height;
    
    return cellHeight;
}
- (IBAction)clickFavour:(UIButton *)button {
    int num = [self.attitudeNum.text intValue];
    if (button.selected) {
        button.selected = NO;
        num -= 1;
        self.attitudeNum.text = [NSString stringWithFormat:@"%d", num];
    }else if (!button.selected)
    {
        button.selected = YES;
        num += 1;
        self.attitudeNum.text = [NSString stringWithFormat:@"%d", num];
        
    }
}

@end
