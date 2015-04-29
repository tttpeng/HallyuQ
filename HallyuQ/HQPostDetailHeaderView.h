//
//  HQPostDetailHeaderView.h
//  HallyuQ
//
//  Created by qingyun on 15/3/28.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQPost;
@interface HQPostDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *userName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewNum;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic,strong) HQPost *post;

-(CGFloat)headerHeightWithPost:(HQPost *)post;

@end
