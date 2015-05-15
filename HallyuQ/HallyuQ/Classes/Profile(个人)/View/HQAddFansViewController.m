//
//  HQAddFansViewController.m
//  HallyuQ
//
//  Created by iPeta on 15/4/2.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQAddFansViewController.h"
#import <AFNetworking.h>
#import "HQUser.h"
#import "HQPost.h"
#import "HQPostCell.h"
#import <MJExtension.h>
#import <MBTwitterScroll.h>
#import <UIImageView+WebCache.h>
#import "MBProgressHUD+MJ.h"
#import "HQNothingCell.h"
#import "HQLoadingCell.h"
@interface HQAddFansViewController ()<UITableViewDataSource,UITableViewDelegate,MBTwitterScrollDelegate>

@property (nonatomic,strong)NSArray *myThreads;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) MBTwitterScroll *myTableView;

@property (nonatomic ,assign)BOOL isLoading;
@end

@implementation HQAddFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    MBTwitterScroll *myTableView = [[MBTwitterScroll alloc] initTableViewWithBackgound:[UIImage imageNamed:@"linyuer"]
                                                                           avatarImage:[UIImage imageNamed:@"avatar"]
                                                                           titleString:_user.nickname
                                                                        subtitleString:@"EXO"
                                                                           buttonTitle:@"关注"];
    
    [myTableView.avatarImage  sd_setImageWithURL:[NSURL URLWithString:_user.icon_url]];
    myTableView.tableView.delegate = self;
    myTableView.tableView.dataSource = self;
    self.myTableView = myTableView;
    myTableView.delegate = self;
    [myTableView.headerButton setTitle:@"已经关注" forState:UIControlStateSelected];
    self.tableView = myTableView.tableView;
    [self.view addSubview:myTableView];
    myTableView.avatarImage.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setBackgroundImage:[UIImage imageNamed:@"icn_nav_bar_back"] forState:UIControlStateNormal];
    backButton.size = backButton.currentBackgroundImage.size;
    backButton.x = 10;
    backButton.y = 30;
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    if (_user) {
        [self isFollow];
        [self.myTableView.tableView reloadData];
        _isLoading = YES;
        [self getData];
    }
 
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, 0, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    label.text = [NSString stringWithFormat:@"粉丝 %@    关注 %@",_user.followers_count,_user.favourites_count];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    return view;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)isFollow
{
    AFHTTPRequestOperationManager *mamager = [AFHTTPRequestOperationManager manager];
    
    mamager.requestSerializer = [AFJSONRequestSerializer serializer];
    mamager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *paramas;
    
    paramas= @{@"user_id":[HQUser currentUser].user_id,@"follower_id":_user.user_id};
    [mamager POST:@"http://hanliuq.sinaapp.com/hlq_api/whetherfollower/" parameters:paramas success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        if ([responseObject[@"data"][@"whether"] integerValue] == 1) {
            self.myTableView.headerButton.selected = YES;
        }else
        {
            self.myTableView.headerButton.selected = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


- (void)getData
{
    AFHTTPRequestOperationManager *mamager = [AFHTTPRequestOperationManager manager];
    NSDictionary *paramas= @{@"user_id":_user.user_id};
   
    [mamager POST:@"http://hanliuq.sinaapp.com/hlq_api/threadbyid/" parameters:paramas success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"---<<>%@",responseObject[@"data"]);
        _myThreads = [HQPost objectArrayWithKeyValuesArray:responseObject[@"data"]];
        _isLoading = NO;
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}



- (void) recievedMBTwitterScrollButtonClickedWithButton:(UIButton *)button {
    
    AFHTTPRequestOperationManager *mamager = [AFHTTPRequestOperationManager manager];
    
    mamager.requestSerializer = [AFJSONRequestSerializer serializer];
    mamager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *paramas;
    if (!button.isSelected) {
        paramas= @{@"user_id":[HQUser currentUser].user_id,@"follow_id":_user.user_id,@"action":@"1"};
    }else
    {
        paramas= @{@"user_id":[HQUser currentUser].user_id,@"follow_id":_user.user_id,@"action":@"0"};
    }
    [mamager POST:@"http://hanliuq.sinaapp.com/hlq_api/add_fans/" parameters:paramas success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"---<<>%@",responseObject);
        
        button.selected = !button.selected;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-----error:%@",error);
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isLoading) {
        return 400;
    }else
    {
        if (_myThreads) {
            HQPostCell *cell = [[NSBundle mainBundle] loadNibNamed:@"HQPostCell" owner:nil options:nil][0];
            HQPost *post = _myThreads[indexPath.row];
            CGFloat cellheight = [cell cellHeightWithPost:post];
            return cellheight;
        }else
            return 400;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isLoading) {
        return 1;
    }else
    {
        if (_myThreads) {
            return _myThreads.count;
        }else
            return 1;
    }
}


-(void)recievedMBTwitterScrollEvent
{

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isLoading) {
        HQLoadingCell *cell = [HQLoadingCell cellWithTableView:tableView];
        return cell;
    }else
    {
        if (_myThreads) {
            HQPostCell *cell = [HQPostCell cellWithTableView:tableView];
            cell.post = _myThreads[indexPath.row];
            return cell;
        }else
        {
            HQNothingCell *cell = [HQNothingCell nothingCellWithTableView:tableView];
            return cell;
        }
    }

}


@end
