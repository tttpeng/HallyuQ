//
//  ZYMusicViewController.m
//  HallyuQ
//
//  Created by Ace on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "ZYMusicViewController.h"
#import "HQNews.h"
#import "HQZiXunListCell.h"
#import "HQHeaderCell.h"
#import "HQNewsDetailViewController.h"

@interface ZYMusicViewController ()

#define kImagesCount 3

@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *titles;

@property (strong, nonatomic) NSMutableArray *newsArray;

@end

@implementation ZYMusicViewController

#pragma mark- 数据懒加载
- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableArray *)titles
{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableArray *)newsArray
{
    if (!_newsArray) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}

//设置分隔线
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

/**
 *  下拉加载最新数据
 */
- (void)loadNewData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"theme_id"] = @"4";
    parameters[@"refresh"] = @"1";
    parameters[@"max_id"] = @"0";
    
    HQNews *firstNews = [self.newsArray firstObject];
    if (firstNews) {
        parameters[@"max_id"] = firstNews.news_id;
    }
    
    [ZYHttpTool post:@"http://hanliuq.sinaapp.com/hlq_api/news/" parameters:parameters success:^(id json) {
        
        if ([json[@"data"] count] >= kImagesCount) {
            for (int i = 0; i < kImagesCount; i++) {
                [self.images addObject:json[@"data"][i][@"image"]];
                [self.titles addObject:json[@"data"][i][@"titile"]];
            }
        }
        
        NSArray *news = [HQNews objectArrayWithKeyValuesArray:json[@"data"]];
        
        //将最新的资讯数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, news.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.newsArray insertObjects:news atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        
        [self.tableView.header endRefreshing];
        
    }];
}


#pragma mark- 上拉刷新
- (void)setupUpRefresh
{
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/**
 *  上拉加载更多数据
 */
- (void)loadMoreData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"theme_id"] = @"4";
    parameters[@"refresh"] = @"2";
    parameters[@"since_id"] = @"0";
    
    HQNews *lastNews = [self.newsArray lastObject];
    if (lastNews) {
        int since_id = lastNews.news_id.intValue - 1;
        parameters[@"since_id"] = @(since_id);
    }
    
    [ZYHttpTool post:@"http://hanliuq.sinaapp.com/hlq_api/news/" parameters:parameters success:^(id json) {
        NSArray *news = [HQNews objectArrayWithKeyValuesArray:json[@"data"]];
        [self.newsArray addObjectsFromArray:news];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.newsArray.count == 0) {
            return 0;
        }else
        {
            return 1;
        }
    }else
    {
        return self.newsArray.count - kImagesCount;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HQHeaderCell *cell = [HQHeaderCell cellWithTableView:tableView];
        if (self.images.count >= kImagesCount) {
            cell.images = self.images;
            cell.titles = self.titles;
        }
        return cell;
    }else
    {
        HQZiXunListCell *cell = [HQZiXunListCell cellWithTableView:tableView];
        cell.news = self.newsArray[indexPath.row + kImagesCount];
        return cell;
    }
}

#pragma mark - Table view data delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 210.0f;
    }else
    {
        return 93.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01f;
    }else
    {
        return 2.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.05f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HQNewsDetailViewController *detail = [[HQNewsDetailViewController alloc] init];
    detail.news = self.newsArray[indexPath.row + 3];
    [self.navigationController pushViewController:detail animated:YES];
}
@end
