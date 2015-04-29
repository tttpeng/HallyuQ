
//
//  HQAccountTabView.m
//  HallyuQ
//
//  Created by iPeta on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#define screenW [UIScreen mainScreen].bounds.size.width


#import "HQAccountTabView.h"
#import <BRYSerialAnimationQueue.h>
#import "HQProfileViewController.h"


@interface HQAccountTabView ()<HQProfileViewcontrollerDelegate>

@property (nonatomic, assign) UIButton *  selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *perDataBtn;
@property (weak, nonatomic) IBOutlet UIButton *myPostBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;

@property (weak, nonatomic) IBOutlet UIView *pickerView;
@end

@implementation HQAccountTabView

+ (HQAccountTabView *)instanceWithFrame:(CGRect)frame withType:(accountTabViewButtonType)type
{
    HQAccountTabView *view = (HQAccountTabView *)[[NSBundle mainBundle] loadNibNamed:@"HQAccountTabView" owner:nil options:nil][0];
    view.frame = frame;
    view.perDataBtn.enabled = NO;
    view.perDataBtn.frame = CGRectMake(0, 0, screenW/3, 40);
    view.myPostBtn.frame = CGRectMake(screenW/3, 0 , screenW/3, 40);
    view.favoriteBtn.frame = CGRectMake(screenW/3 * 2, 0, screenW/3, 40);
    view.pickerView.frame = CGRectMake(0, 33, screenW / 3, 7);
    
    view.selectedButton = view.perDataBtn;
    return view;
}



- (IBAction)perDatabtnCkick:(UIButton *)sender {
    [self.delegate accountTabViewButtonClickWithType:accountTabViewButtonTypeMyData];
    [self profileViewContorllerDidReloadDataWithType:accountTabViewButtonTypeMyData];
    sender.enabled = NO;
    self.selectedButton.enabled = YES;
    self.selectedButton  = sender;
}

- (void)profileViewContorllerDidReloadDataWithType:(accountTabViewButtonType)type
{
    BRYSerialAnimationQueue *queue = [[BRYSerialAnimationQueue alloc] init];
    [queue animateWithDuration:0.3 animations:^{
                self.pickerView.x = screenW/3 * (type - 101);
    }];
}



- (IBAction)postBtnClick:(UIButton *)sender {
    sender.enabled = NO;
    self.selectedButton.enabled = YES;
    self.selectedButton  = sender;
    [self.delegate accountTabViewButtonClickWithType:accountTabViewButtonTypeNews];
    [self profileViewContorllerDidReloadDataWithType:accountTabViewButtonTypeNews];
    
}
- (IBAction)favoriteBtnClick:(UIButton *)sender {
    sender.enabled = NO;
    self.selectedButton.enabled = YES;
    self.selectedButton  = sender;
    [self.delegate accountTabViewButtonClickWithType:accountTabViewButtonTypeThread];
    [self profileViewContorllerDidReloadDataWithType:accountTabViewButtonTypeThread];
}



@end
