//
//  HQAccountTitleView.m
//  HallyuQ
//
//  Created by iPeta on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQAccountTitleView.h"
#import "HQUser.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface HQAccountTitleView ()


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@end


@implementation HQAccountTitleView

+ (HQAccountTitleView *)instanceWithFrame:(CGRect)frame
{
    HQAccountTitleView *view = (HQAccountTitleView *)[[NSBundle mainBundle] loadNibNamed:@"HQAccountTitleView" owner:nil options:nil][0];
    
    return view;
}

-(void)setUser:(HQUser *)user{
    _user = user;
    [_fansBtn setTitle:[NSString stringWithFormat:@"%@ 粉丝",_user.followers_count] forState:UIControlStateNormal];
    [_followBtn setTitle:[NSString stringWithFormat:@"关注 %@",_user.favourites_count] forState:UIControlStateNormal ];
    self.nameLabel.text = user.nickname;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_user.icon_url]
placeholderImage:[UIImage imageNamed:@"icon"]];
    _iconImageView.layer.cornerRadius = _iconImageView.bounds.size.width * 0.5;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconImageView.layer.borderWidth = 3;

}
- (IBAction)editBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(accountTitleView:DidClickTitleBtn:)] ) {
        [self.delegate accountTitleView:self DidClickTitleBtn:accountTitleViewButtonTypeEdit];
    }
}
- (IBAction)settingBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(accountTitleView:DidClickTitleBtn:)] ) {
        [self.delegate accountTitleView:self DidClickTitleBtn:accountTitleViewButtonTypeSetting];
    }
}
- (IBAction)followBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(accountTitleView:DidClickTitleBtn:)
        ]) {
        [self.delegate accountTitleView:self DidClickTitleBtn:accountTitleViewButtonTypeFollow];
        
    }
}
- (IBAction)fansBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(accountTitleView:DidClickTitleBtn:)
         ]) {
        [self.delegate accountTitleView:self DidClickTitleBtn:accountTitleViewButtonTypeFans];
        
    }
}
@end
