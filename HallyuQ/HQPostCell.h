//
//  HQPostCell.h
//  HallyuQ
//
//  Created by qingyun on 15/3/25.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQPostCell;

@protocol HQPostCellDelegate <NSObject>

- (void)postCell:(HQPostCell *)cell nameClickedButton:(UIButton *)button;

@end

@class HQPost;
@interface HQPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIView *recordView;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (nonatomic,strong) HQPost *post;
@property (nonatomic,strong) UIButton *playButton;

@property (nonatomic,weak) id <HQPostCellDelegate> delegate;

-(CGFloat)cellHeightWithPost:(HQPost *)post;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
