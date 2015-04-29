//
//  HQPostDetailCell.m
//  HallyuQ
//
//  Created by qingyun on 15/3/28.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQPostDetailCell.h"
#import "HQComment.h"
#import <UIImageView+WebCache.h>
@implementation HQPostDetailCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width, 1));
    
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"postDetailCell";
    HQPostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HQPostDetailCell alloc] init];
        cell = [[NSBundle mainBundle] loadNibNamed:@"HQPostDetailCell" owner:nil options:nil][0];
    }
    return cell;
}
-(void)setComment:(HQComment *)comment
{
    _comment = comment;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:comment.avatar_img] placeholderImage:nil];
    [self.userName setTitle:comment.usr_name forState:UIControlStateNormal];
    self.commentLabel.text = comment.content_text;
    self.floorLable.text = [NSString stringWithFormat:@"%ld楼",comment.floor_num];
    self.timeLabel.text = comment.date;
}
-(CGFloat)cellHeightWithComment:(HQComment *)comment
{
    
    CGFloat cellHeight = 0;
    self.commentLabel.text = comment.content_text;
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = self.commentLabel.font;
    CGSize contentSize = [comment.content_text sizeWithAttributes:attri];
    cellHeight += contentSize.height;
    CGSize cellSize = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    cellHeight += cellSize.height;
    return cellHeight;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
