//
//  HQPostDetailHeaderView.m
//  HallyuQ
//
//  Created by qingyun on 15/3/28.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQPostDetailHeaderView.h"
#import "HQPost.h"
#import <UIImageView+WebCache.h>
#import "HQUser.h"
@implementation HQPostDetailHeaderView

-(instancetype)init
{
    if (self = [super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"HQPostDetailHeaderView" owner:nil options:nil][0];

    }
    
    return self;
}
-(void)setPost:(HQPost *)post
{
    _post = post;
    for (UIView *subView in self.picView.subviews) {
        [subView removeFromSuperview];
    }
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:post.user.icon_url]];
    [self.userName setTitle:post.user.nickname forState:UIControlStateNormal];
    self.date.text = post.date;
    self.titleLabel.text = post.titile;
    self.contentLabel.text = post.content;
    if ([post.user.gender integerValue] == 1) {
        [self.sexButton setImage:[UIImage imageNamed:@"icon_chat_boy"] forState:UIControlStateNormal];
    }else if([post.user.gender integerValue] == 0)
    {
        [self.sexButton setImage:[UIImage imageNamed:@"cent_icon_girl_n"] forState:UIControlStateNormal];
    }
    if (post.views > 999) {
        self.viewNum.text = [NSString stringWithFormat:@"浏览999+"];
    }else
    {
        self.viewNum.text = [NSString stringWithFormat:@"浏览%ld",post.views];
    }
    if (post.image.length > 44) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width-16, (self.width-16) * 9/16)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:post.image] placeholderImage:nil];
        for (NSLayoutConstraint *constraint in self.picView.constraints) {
            if(constraint.firstAttribute == NSLayoutAttributeHeight){
                constraint.constant = (self.width-16) * 9/16;
            }
        }
        [self.picView addSubview:imageView];
    }else
    {
        for (NSLayoutConstraint *constraint in self.picView.constraints) {
            if(constraint.firstAttribute == NSLayoutAttributeHeight){
                constraint.constant = 0;
            }
        }
    }

}
-(CGFloat)headerHeightWithPost:(HQPost *)post
{
    CGFloat headerHeight = 0;
    self.titleLabel.text = post.titile;
    NSMutableDictionary *attr1 = [NSMutableDictionary dictionary];
    attr1[NSFontAttributeName] = self.titleLabel.font;
    CGSize size1 = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.width-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr1 context:nil].size;
    headerHeight += size1.height;
    if (post.image.length > 44) {
        headerHeight += (self.width -16) * 9/16;
    }
    self.contentLabel.text = post.content;
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = self.contentLabel.font;
    CGSize size = [self.contentLabel.text boundingRectWithSize:CGSizeMake(self.width-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    headerHeight += size.height;
     //self.contentLabel.preferredMaxLayoutWidth = self.width-16;
    return headerHeight +100;
    
    
}

@end
