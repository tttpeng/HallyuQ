//
//  HQPostCell.m
//  HallyuQ
//
//  Created by qingyun on 15/3/25.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQPostCell.h"
#import "HQPost.h"
#import <UIImageView+WebCache.h>
#import "HQUser.h"
#import "HQRecordViewController.h"
@implementation HQPostCell

- (void)awakeFromNib {
    // Initialization code
}



+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"postCell";
    HQPostCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HQPostCell alloc] init];
        cell = [[NSBundle mainBundle] loadNibNamed:@"HQPostCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.baseView.layer.borderColor = [UIColor colorWithWhite:0.785 alpha:1.000].CGColor;
        cell.baseView.layer.borderWidth = 1;
        cell.baseView.layer.cornerRadius = 3;
        
        cell.iconImage.layer.cornerRadius = 3;
        cell.iconImage.layer.masksToBounds = YES;
        
    }
    return cell;
}

- (IBAction)buttonClicked:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(postCell:nameClickedButton:)]) {
        [self.delegate postCell:self nameClickedButton:sender];
    }
}
- (IBAction)tapIocn:(UITapGestureRecognizer *)sender {
}


- (void)animation:(UIButton *)button
{
    
    
}

-(void)setPost:(HQPost *)post
{
    _post = post;
   //移除重用cell上的视图
    NSArray *subViews = self.recordView.subviews;
    for (UIView *button in subViews) {
        [button removeFromSuperview];
    }
    //设置用户名
    [self.nameButton setTitle:post.user.nickname forState:UIControlStateNormal];
    [self.nameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //设置主题
    self.titleLable.text = post.titile;
    
    //设置时间
    self.timeLable.text = post.date;
    //设置正文
    self.contentLable.text = post.content;
    HQUser *user = post.user;
    //NSLog(@"%@===================",user.profile_image_url);
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:user.icon_url] placeholderImage:nil];
    
    if ([post.sound_url containsString:@".aac"]) {
         //[self.recordView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 150, 30)];
        [playButton setImage:[UIImage imageNamed:@"icon_sounds3_n"] forState:UIControlStateNormal];
        [playButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_reply"] forState:UIControlStateNormal];
        [playButton setTag:300];
        if (playButton.selected) {
            [self animation:playButton];
        }
        
        playButton.layer.cornerRadius = 3;
        playButton.layer.masksToBounds = YES;
        playButton.backgroundColor = [UIColor orangeColor];
        playButton.userInteractionEnabled = YES;
        for (NSLayoutConstraint *constraint in self.recordView.constraints) {
            if(constraint.firstAttribute == NSLayoutAttributeHeight){
                constraint.constant = 30;
            }
        }
        [self.recordView addSubview:playButton];
         self.playButton = playButton;
       }else
       {
           for (NSLayoutConstraint *constraint in self.recordView.constraints) {
               if(constraint.firstAttribute == NSLayoutAttributeHeight){
                   constraint.constant = 0;
               }
           }
       }
    NSArray *subViews1 = self.pictureView.subviews;
    for (UIView *subView in subViews1) {
        [subView removeFromSuperview];
    }
    if (post.image.length > 44)
    {
        //[self.pictureView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:post.image] placeholderImage:nil];
        for (NSLayoutConstraint *constraint in self.pictureView.constraints) {
            if(constraint.firstAttribute == NSLayoutAttributeHeight){
                constraint.constant = 150;
            }
        }
        [self.pictureView addSubview:imageView];
    }else
    {
        for (NSLayoutConstraint *constraint in self.pictureView.constraints) {
            if(constraint.firstAttribute == NSLayoutAttributeHeight){
                constraint.constant = 0;
            }
        }
    }
}

//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width, 1));
//    
//}
-(CGFloat)cellHeightWithPost:(HQPost *)post
{
    CGFloat cellHeight = 0;
    
    self.titleLable.text = post.titile;
    self.titleLable.preferredMaxLayoutWidth = self.width - 40;
    self.contentLable.text = post.content;
    self.contentLable.preferredMaxLayoutWidth = self.width - 40;
    if (post.sound_url.length > 44) {
        cellHeight += 30;
    }
    if (post.image.length > 44) {
        cellHeight += 150;
    }
    CGSize cellSize = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    cellHeight += cellSize.height;
    return cellHeight +1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

@end
