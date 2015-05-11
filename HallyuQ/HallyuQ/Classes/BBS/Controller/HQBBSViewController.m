//
//  HQBBSViewController.m
//  HallyuQ
//
//  Created by iPeta on 15/3/19.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQBBSViewController.h"
#import <AFNetworking.h>
#import "HQPostController.h"
#import <MJExtension.h>
#import "HQPost.h"
#import "HQPostCell.h"
#import "HQPostHeaderCell.h"
#import "HQPostDetailViewController.h"
#import "HQRecordViewController.h"
#import <MJRefresh.h>
#import "HQAddFansViewController.h"
#import "HQUser.h"

@interface HQBBSViewController ()<UIScrollViewDelegate,HQPostCellDelegate>

@property (nonatomic, weak) UIButton *leftButton;
@property (nonatomic,strong) NSMutableArray *postsArray;
@end

@implementation HQBBSViewController


-(NSMutableArray *)postsArray
{
    if (!_postsArray) {
        _postsArray = [NSMutableArray array];
    }
    return _postsArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setNavBar];
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
    }];
    [self.tableView.legendHeader beginRefreshing];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidden) name:@"navHidden" object:nil];
}


- (void)loadNewData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters;
    
    if (self.postsArray.count != 0) {
        HQPost *post = [self.postsArray firstObject];
        parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"since_id":post.ID, @"refresh":@"1"}];
    }else
    {
        parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"max_id":@"0",@"refresh":@"1"}];
    }
    // 设置请求格式
    // manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/thread/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSArray *postArray = [HQPost objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //NSLog(@"%@]]]]]]]]]]]]]]]]]",postArray);
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:postArray];
        if (self.postsArray.count != 0) {
            [tempArray addObjectsFromArray:self.postsArray];
        }
        self.postsArray = tempArray;
        //NSDictionary *dataDic = responseObject[@"data"];
        //HQUser *user = [HQUser objectWithKeyValues:dataDic[@"user"]];
        [self.tableView.legendHeader endRefreshing];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.tableView.legendHeader endRefreshing];
    }];
    
}
- (void)loadMoreData
{
    //获取bbs列表
    NSMutableDictionary *parameters;
    if (self.postsArray.count != 0) {
        HQPost *post = [self.postsArray lastObject];
        //        NSInteger maxID = [post.ID integerValue] -1;
        parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"since_id":post.ID,@"refresh":@"2"}];
        
        if ([post.ID integerValue] > 157) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            //NSDictionary *parameters = @{@"max_id":post.ID, @"refresh":@"1"};
            // 设置请求格式
            //manager.requestSerializer = [AFJSONRequestSerializer serializer];
            // 设置返回格式
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/thread/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSArray *postArray = [HQPost objectArrayWithKeyValuesArray:responseObject[@"data"]];
                //NSLog(@"%@]]]]]]]]]]]]]]]]]",postArray);
                [self.postsArray addObjectsFromArray:postArray];
                //NSDictionary *dataDic = responseObject[@"data"];
                //HQUser *user = [HQUser objectWithKeyValues:dataDic[@"user"]];
                [self.tableView.legendFooter endRefreshing];
                
                [self.tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
    }
}
- (void)hidden
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)setNavBar
{
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleView.text = @"论坛";
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.font = [UIFont boldSystemFontOfSize:18];
    titleView.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleView;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"rightCreate_Nav"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
}

//- (void)setData
//{
////    获取bbs列表
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *parameters = @{@"max_id":@"0", @"refresh":@"1"};
//        // 设置请求格式
//       // manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        // 设置返回格式
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/thread/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"JSON: %@", responseObject);
//        NSArray *postArray = [HQPost objectArrayWithKeyValuesArray:responseObject[@"data"]];
//        //NSLog(@"%@]]]]]]]]]]]]]]]]]",postArray);
//        [self.postsArray addObjectsFromArray:postArray];
//        //NSDictionary *dataDic = responseObject[@"data"];
//        //HQUser *user = [HQUser objectWithKeyValues:dataDic[@"user"]];
//        [self.tableView reloadData];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
//
//
//}



- (void)rightBarButtonItemClick
{
    HQPostController *postVC = [[HQPostController alloc] init];
    [self.navigationController pushViewController:postVC animated:NO];
    postVC.navigationController.navigationBarHidden = YES;
    //[self presentViewController:postVC animated:YES completion:nil];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.postsArray.count;
}

#pragma mark -- postCell delegate

-(void)postCell:(HQPostCell *)cell nameClickedButton:(UIButton *)button
{
    HQAddFansViewController *fansVC = [[HQAddFansViewController alloc] init];
    fansVC.user = cell.post.user;
    [self.navigationController pushViewController:fansVC animated:YES];
}

#pragma mark - UIScrollViewDelegate 代理方方法

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HQPostCell *cell = [HQPostCell cellWithTableView:tableView];
    cell.post = self.postsArray[indexPath.row];
    cell.delegate = self;
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HQPostCell *cell = [[NSBundle mainBundle] loadNibNamed:@"HQPostCell" owner:nil options:nil][0];
    HQPost *post = self.postsArray[indexPath.row];
    CGFloat cellheight = [cell cellHeightWithPost:post];
    return cellheight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQPost *post = self.postsArray[indexPath.row];
    if ([post.sound_url containsString:@".aac"]) {
        HQRecordViewController *reVC = [[HQRecordViewController alloc] init];
        reVC.urlStr = post.sound_url;
        [self presentViewController:reVC animated:YES completion:nil];
        
    }else
    {
        HQPostDetailViewController *detailVC = [[HQPostDetailViewController alloc] init];
        detailVC.post = self.postsArray[indexPath.row];
        self.navigationItem.title = @"正文";
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}



@end
