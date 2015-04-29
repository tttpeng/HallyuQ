//
//  HQProfileViewController.m
//  HallyuQ
//
//  Created by iPeta on 15/3/19.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQProfileViewController.h"
#import <AFNetworking.h>
#import "HQAccountTitleView.h"
#import "HQAccountTabView.h"
#import "HQEditingViewController.h"
#import "HQAddFansViewController.h"
#import "HQSettingViewController.h"
#import "HQPerDataCell.h"
#import "HQUser.h"
#import "HQPost.h"
#import "HQNews.h"
#import "HQZiXunListCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "HQNothingCell.h"
#import "HQLoadingCell.h"
#import "HQPostCell.h"
#import "HQFansViewController.h"
#import "HQDbTool.h"
#import "HQFollowViewController.h"


@interface HQProfileViewController ()<UITableViewDataSource,UITableViewDelegate,HQAccountTitleViewDelegate,HQAccountTabViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign)accountTabViewButtonType currentType;
@property (nonatomic, assign)accountTabViewButtonType preType;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, assign)BOOL isLayout;
@property (nonatomic, assign)BOOL isGo;
@property (nonatomic, strong) HQAccountTabView *tabView;
@property (nonatomic, weak) HQAccountTitleView *titleView;

@end

@implementation HQProfileViewController

- (void)viewDidLoad {
    
    self.user = [HQUser currentUser];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    UIView *cyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH * 0.5)];
    cyView.backgroundColor = [UIColor colorWithRed:0.894 green:0.282 blue:0.467 alpha:1.000];
    [self.view addSubview:cyView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, screenW,screenH - 69) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate=  self;
    self.tableView.dataSource = self;
    [super viewDidLoad];
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 20)];
    statusView.backgroundColor = [UIColor colorWithRed:0.894 green:0.282 blue:0.467 alpha:1.000];
    [self.view addSubview:statusView];
    
    HQAccountTitleView *titleView = [HQAccountTitleView instanceWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 100)];
    titleView.delegate = self;
    titleView.user = _user;
    self.titleView = titleView;
    self.tableView.tableHeaderView = titleView;
    self.tableView.tableFooterView = [UIView new];
    self.navigationController.navigationBarHidden = YES;
    
    
    _currentType = accountTabViewButtonTypeMyData;
    _isLayout = NO;
    
    HQAccountTabView *view = [HQAccountTabView instanceWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40) withType:_currentType];
    self.delegate = view;
    view.delegate =  self;
    self.tabView = view;

    
//    self.tabBarController.hidesBottomBarWhenPushed = NO;
    
    [self testDatabase];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    if (![HQUser currentUser]){
        self.tabBarController.selectedIndex = 0;
    }else
    {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];    NSDictionary *parameters = @{@"user_id":[HQUser currentUser].user_id};
    [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/getuserbyid/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        HQUser *user = [HQUser objectWithKeyValues:responseObject[@"data"]];
        [HQUser saveWithUser:user];
        self.titleView.user = user;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    }

}


- (void)testDatabase
{
    
//    NSArray *array = [HQDbTool threadCommentsWithThreadId:@"202"];
//    NSDictionary *dict = array[0];

    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
////    manager.responseSerializer = [AFJSONResponseSerializer serializer];
////    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    NSDictionary *parameters = @{@"bbs_id":@"202"};
//    
////    NSDictionary *parameters = @{@"refresh":@"1",@"max_id":@"0"};
//    [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/posts/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//        [HQDbTool saveThreadComment:responseObject[@"data"]];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

- (void)testGetDate
{
    //获取bbs列表
    
    
    //收藏 bbs_id =148; message_id = 29 user id= 146；
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    UIImage *image =[UIImage imageNamed:@"1"];
    //    NSData *data = UIImagePNGRepresentation(image);
    //    NSString *ster = [data base64EncodedStringWithOptions:0];
    //        NSDictionary *parameters = @{@"userid": @"146",@"title":@"111111111",@"content":@"1",@"image":ster};
    //    NSDictionary *parameters = @{@"theme_id":@"0",@"refresh":@"1",@"max_id":@"0"};
    //     NSDictionary *parameters = @{@"message_id":@"32",@"type":@"1",@"userid":@"146",@"action":@"0"};
    //    NSDictionary *parameters = @{@"title":@"sdasdasd",@"content":@"1",@"theme_id":@"2",@"author":@"asda"};
    NSDictionary *parameters = @{@"user_id":@"146"};
    
    
    
    [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/getuserbyid/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *dict in array) {
            NSLog(@"--->%@",dict[@"theme"]);
        }
        //            NSLog(@"--------%d",array.count);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    //获取收藏
    //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //        NSDictionary *parameters1 = @{@"userid": @"146"};
    //        [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/news/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //            NSLog(@"JSON: %@", responseObject);
    //        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //            NSLog(@"Error: %@", error);
    //        }];
    
    
    //发表评论
    //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //        NSDictionary *parameters = @{@"messageid":@"29"};
    //        [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/comment/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //            NSLog(@"JSON: %@", responseObject);
    //        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //            NSLog(@"Error: %@", error);
    //        }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (_currentType) {
        case accountTabViewButtonTypeMyData:
            return 1;
            break;
            
        case accountTabViewButtonTypeNews:
        case accountTabViewButtonTypeThread:
            if (_dataArray) {
                return _dataArray.count;
            }else
            {
                return 1;
            }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_currentType) {
        case accountTabViewButtonTypeMyData:
            return 450;
            break;
        case accountTabViewButtonTypeNews:
            if (_dataArray) {
                return 93;
            }else
            {
                return 500;
            }
            break;
            
        case accountTabViewButtonTypeThread:
            if (_dataArray) {
                return 221;
            }else
            {
                return 500;
            }
            break;
            
            
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _tabView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (_currentType) {
            case accountTabViewButtonTypeMyData:
            {
                HQPerDataCell *cell = [HQPerDataCell cellWithTableView:tableView];
                cell.user = _user;
                return cell;
                break;
            }
            case accountTabViewButtonTypeNews:
            {
                if (!_dataArray) {
                    if (_isGo) {
                        HQLoadingCell *cell = [HQLoadingCell  cellWithTableView:tableView];
                        return cell;
                    }else                    {
                        HQNothingCell *cell = [HQNothingCell nothingCellWithTableView:tableView];
                        return cell;
                    }
                }else
                {
                    
                    HQZiXunListCell *cell = [HQZiXunListCell cellWithTableView:tableView];
                    cell.news = self.dataArray[indexPath.row];
                    return cell;
                }
                break;
            }
                
            case accountTabViewButtonTypeThread:
            {
                if (!_dataArray) {
                    if (_isGo) {
                        HQLoadingCell *cell = [HQLoadingCell  cellWithTableView:tableView];
                        return cell;
                    }else                    {
                        HQNothingCell *cell = [HQNothingCell nothingCellWithTableView:tableView];
                        return cell;
                    }
                }else
                {
                    HQPostCell *cell = [HQPostCell cellWithTableView:tableView];
                    cell.post = self.dataArray[indexPath.row];
                    return cell;
                }
                break;
                
            }
            default:
                break;
        }
    }
    return nil;
    
}



#pragma mark - tabView 代理方法
- (void)accountTabViewButtonClickWithType:(accountTabViewButtonType)type
{
    switch (type) {
        case accountTabViewButtonTypeMyData:
            
        {_preType = _currentType;
            _currentType = accountTabViewButtonTypeMyData;
            _user = [HQUser currentUser];
            self.isLayout = YES;
            NSMutableArray *dictArray = [NSMutableArray array];
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [dictArray addObject:path];
            [self.tableView reloadData];
//            [self.delegate profileViewContorllerDidReloadDataWithType:_currentType];
        }
            break;
        case accountTabViewButtonTypeNews:
            _preType = _currentType;
            _currentType = accountTabViewButtonTypeNews;
            _dataArray = nil;
            [self.tableView reloadData];
//            [self.delegate profileViewContorllerDidReloadDataWithType:_currentType];
            _isGo = YES;
            [self getDataWithType:(accountTabViewButtonTypeNews)];
            break;
        case accountTabViewButtonTypeThread:
            _preType = _currentType;
            _currentType = accountTabViewButtonTypeThread;
            _dataArray = nil;
            self.isLayout = YES;
            [self.tableView reloadData];
            _isGo = YES;
//            [self.delegate profileViewContorllerDidReloadDataWithType:_currentType];
            [self getDataWithType:accountTabViewButtonTypeThread];
            break;
        default:
            break;
    }
}


- (void)getDataWithType:(accountTabViewButtonType)type
{
    //获取bbs列表
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"type":[NSString stringWithFormat:@"%d",type - 101],@"user_id":[HQUser currentUser].user_id};
    [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/getcollect/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"json :%@",responseObject);
        NSArray *jsonArray = responseObject[@"data"];
        if (type == accountTabViewButtonTypeNews) {
            self.dataArray = [HQNews objectArrayWithKeyValuesArray:jsonArray];
            _currentType = accountTabViewButtonTypeNews;
        }else
        {
            self.dataArray = [HQPost objectArrayWithKeyValuesArray:jsonArray];
            _currentType = accountTabViewButtonTypeThread;
        }
        NSMutableArray *dictArray = [NSMutableArray array];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [dictArray addObject:path];
        _isGo = NO;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        _isGo = NO;
        [self.tableView reloadData];
    }];
    
}


#pragma mark - titleView 代理方法
- (void)accountTitleView:(HQAccountTitleView *)titleView DidClickTitleBtn:(accountTitleViewButtonType)buttonIndex
{
    switch (buttonIndex) {
        case accountTitleViewButtonTypeEdit:
        {
            HQEditingViewController *editVc = [[HQEditingViewController alloc] init];
            [self.navigationController pushViewController:editVc animated:YES];
        }
            break;
        case accountTitleViewButtonTypeSetting:
        {
            HQSettingViewController *settingVc = [[HQSettingViewController alloc] init];
            [self.navigationController pushViewController:settingVc animated:YES];
        }
            break;
        case accountTitleViewButtonTypeFans:
        {
            HQFansViewController *fansVc = [[HQFansViewController alloc] init];
            fansVc.index = 1;
            //          HQSettingViewController *settingVc = [[HQSettingViewController alloc] init];
            [self.navigationController pushViewController:fansVc animated:YES];
        }
            break;

        case accountTitleViewButtonTypeFollow:
        {
            HQFansViewController *followVc = [[HQFansViewController alloc] init];
            followVc.index = 2;
            [self.navigationController pushViewController:followVc animated:YES];
        }
            break;

        default:
            break;
    }
    
}

@end
