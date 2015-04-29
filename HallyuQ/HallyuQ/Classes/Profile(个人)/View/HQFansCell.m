//
//  HQFansCell.m
//  HallyuQ
//
//  Created by iPeta on 15/4/2.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQFansCell.h"
#import "HQUser.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>

@interface HQFansCell ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UIButton *followbtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation HQFansCell




+ (instancetype)cellWithTableview:(UITableView *)tableView
{
    
    static NSString *identifier = @"HQFansCell";
    HQFansCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HQFansCell alloc] init];
        cell = [[NSBundle mainBundle] loadNibNamed:@"HQFansCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.iconView.layer.borderWidth = 1;
        cell.iconView.layer.cornerRadius = 4;
        cell.iconView.layer.masksToBounds = YES;

        cell.followbtn.layer.borderColor = [UIColor colorWithRed:0.297 green:0.629 blue:0.930 alpha:1.000].CGColor;
        cell.followbtn.layer.borderWidth = 1;
        cell.followbtn.layer.cornerRadius = 4;
        cell.followbtn.layer.masksToBounds = YES;

        
    }
    return cell;
}
- (IBAction)followBtnClick:(id)sender {
    if (_followbtn.isSelected) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:_user.nickname delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消关注" otherButtonTitles:nil];
        
        [sheet showInView:self];
        
    }else
    {
        [self followingWithType:@"1"];
    }
}

- (void)isFollow
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *paramas;
    
    paramas= @{@"user_id":[HQUser currentUser].user_id,@"follower_id":_user.user_id};
    [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/whetherfollower/" parameters:paramas success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        if ([responseObject[@"data"][@"whether"] integerValue] == 1) {
            _followbtn.selected = YES;
        }else
        {
            _followbtn.selected = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)followingWithType:(NSString *)action
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSDictionary *paramas= @{@"user_id":[HQUser currentUser].user_id,@"follow_id":_user.user_id,@"action":action};
    [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/add_fans/" parameters:paramas success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"---<<>%@",responseObject);
        
        _followbtn.selected = !_followbtn.selected;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-----error:%@",error);
    }];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self followingWithType:@"0"];
    }
       
}
- (void)setUser:(HQUser *)user
{
    _user = user;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
    _nameLabel.text  = user.nickname;
    [self isFollow];
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
