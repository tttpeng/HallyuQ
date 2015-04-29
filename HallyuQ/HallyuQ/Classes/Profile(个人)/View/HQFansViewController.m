//
//  HQFansViewController.m
//  HallyuQ
//
//  Created by iPeta on 15/4/2.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQFansViewController.h"
#import "HQUser.h"
#import "HQFansCell.h"
#import <AFNetworking.h>
#import "HQBaseBarView.h"
#import "HQAddFansViewController.h"
@interface HQFansViewController ()<HQBaseBarViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSArray *fansArray;
@property (nonatomic, strong)HQUser *followUser;
@property (nonatomic, weak) UITableView  *tableView;
@end

@implementation HQFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_index == 1) {
        self.barView.titleLabel.text = @"粉丝";
    }else
    {
        self.barView.titleLabel.text = @"关注";
    }
    self.view.backgroundColor = [UIColor colorWithRed:0.541 green:0.745 blue:0.035 alpha:1.000];
    UITableView *tableView =[[UITableView alloc] init];
    tableView.frame = [UIScreen mainScreen].bounds;
    self.tableView = tableView;
    tableView.y = 64;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];

    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
                [tableView setSeparatorInset:UIEdgeInsetsZero];
            }
    
    [self.view addSubview:tableView];
    [self getFansData];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}
- (void)getFansData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *paramas = @{@"user_id":@"146",@"type":[NSString stringWithFormat:@"%lu",(unsigned long)_index ]};
    [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/follower/" parameters:paramas success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----#_---------%@",responseObject);
        _fansArray = [HQUser objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求错误");
    }];
    
}


#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _fansArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HQFansCell *cell = [HQFansCell cellWithTableview:tableView];
    cell.user = _fansArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HQAddFansViewController *addFans = [[HQAddFansViewController alloc] init];
    addFans.user = _fansArray[indexPath.row];
    [self.navigationController pushViewController:addFans animated:YES];
}

@end
