//
//  ZYHomeViewController.m
//  HallyuQ
//
//  Created by Ace on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "ZYHomeViewController.h"
#import "HQHomeHeaderCell.h"
#import "HQZiXunListCell.h"
#import "HQNews.h"
#import "HQNewsDetailViewController.h"
#import <MJRefreshHeader.h>
#import "HQDbTool.h"

@interface ZYHomeViewController ()

@property (strong, nonatomic) NSMutableArray *newsArray;

@end

@implementation ZYHomeViewController

#pragma mark- 数据处理
- (NSMutableArray *)newsArray
{
    if (!_newsArray) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

//将分隔线充满一行
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 10)];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
}

//解决从详情页返回后，cell的选中状态不取消的bug
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.926 alpha:1.000];
    
    
    //集成下拉刷新控件
    [self setupDownRefresh];
    
    //集成上拉刷新控件
    [self setupUpRefresh];
    
}

#pragma mark- 下拉刷新
- (void)setupDownRefresh
{
    
    //1.添加刷新控件
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    //2.进入刷新状态
    [self.tableView.header beginRefreshing];

}

- (void)loadNewData
{
    //1.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"theme_id"] = @"0";
    
    HQNews *firstNews = [self.newsArray firstObject];
    if (firstNews) {
        parameters[@"max_id"] = firstNews.news_id;
        parameters[@"refresh"] = @"1";
    }
    
    //2.定义一个block块处理返回的字典数据
    void (^dealResult)(NSArray *) = ^(NSArray *newses){
        NSArray *news = [HQNews objectArrayWithKeyValuesArray:newses];
        
        //将最新的资讯数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, news.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.newsArray insertObjects:news atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.header endRefreshing];
    };
    
    //3.先尝试从数据库中加载数据
    NSArray *newses = [HQDbTool newsWithParamas:parameters];
    if (newses.count) {
        dealResult(newses);
    }else
    {
        [ZYHttpTool post:@"http://hanliuq.sinaapp.com/hlq_api/news/" parameters:parameters success:^(id json) {
            //        NSLog(@"%@", json);
            
            [HQDbTool saveNews:json[@"data"]];
            
            dealResult(newses);
            
        } failure:^(NSError *error) {
            
            NSLog(@"刷新新数据，请求失败！-%@", error);
            [self.tableView.header endRefreshing];
            
        }];
    }
    
    
}

#pragma mark- 上拉刷新
- (void)setupUpRefresh
{
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/**
 *  上拉刷新加载更多数据
 */
- (void)loadMoreData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"theme_id"] = @"0";
    
    HQNews *lastnews = [self.newsArray lastObject];
    if (lastnews) {
        parameters[@"refresh"] = @"2";
        
        int since_id = lastnews.news_id.intValue - 1;
        parameters[@"since_id"] = @(since_id);
    }
    
    void (^dealResult)(NSArray *) = ^(NSArray *newses){
      
        NSArray *news = [HQNews objectArrayWithKeyValuesArray:newses];
        [self.newsArray addObjectsFromArray:news];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.footer endRefreshing];
        
    };
        
    NSArray *newses = [HQDbTool newsWithParamas:parameters];
    if (newses.count) {
        dealResult(newses);
    }else
    {
        [ZYHttpTool post:@"http://hanliuq.sinaapp.com/hlq_api/news/" parameters:parameters success:^(id json) {
            
            [HQDbTool saveNews:json[@"data"]];
            
            dealResult(newses);
            
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
            [self.tableView.footer endRefreshing];
        }];
    }
    
   
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.newsArray.count == 0) {
            return 0;
        }else
        {
            return 1;
        }
    }else
    {
        return self.newsArray.count - 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HQHomeHeaderCell *cell = [HQHomeHeaderCell cellWithTableView:tableView];
        cell.news = self.newsArray[indexPath.row];
        return cell;
    }else
    {
        HQZiXunListCell *cell = [HQZiXunListCell cellWithTableView:tableView];
        cell.news = self.newsArray[indexPath.row + 1];
        return cell;
    }
}


#pragma mark - Table view data delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 260.f;
    }else{
        return 94.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 5.0f;
    }else
    {
        return 10.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.05f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HQNewsDetailViewController *detail = [[HQNewsDetailViewController alloc] init];
    if (indexPath.section == 0) {
        detail.news = self.newsArray[indexPath.row];
    }else
    {
        detail.news = self.newsArray[indexPath.row + 1];
    }
    [self.navigationController pushViewController:detail animated:YES];
}

@end
