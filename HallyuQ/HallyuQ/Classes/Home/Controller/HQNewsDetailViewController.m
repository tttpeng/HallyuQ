//
//  HQNewsDetailViewController.m
//  HallyuQ
//
//  Created by Ace on 15/3/30.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQNewsDetailViewController.h"
#import "HQNewsDetailHeaderView.h"
#import "HQNewsDetailToolBar.h"
#import "HQNewsCommentCell.h"
#import "ZYHttpTool.h"
#import "HQNews.h"
#import "HQNewsComment.h"
#import "HQNewsCommentViewController.h"
#import <AFNetworking.h>


@interface HQNewsDetailViewController () <UITableViewDataSource, UITableViewDelegate, HQNewsDetailToolbarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat offsetY;
/**
 *  工具条
 */
@property (nonatomic, weak) HQNewsDetailToolBar *toolbar;

@property (strong, nonatomic) NSMutableArray *newComments;

@property (strong, nonatomic) NSMutableArray *allComments;

@end

@implementation HQNewsDetailViewController

- (NSMutableArray *)newComments
{
    if (!_newComments) {
        _newComments = [NSMutableArray array];
    }
    return _newComments;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarHidden = YES;
//    self.navigationController.navigationBar.hidden = YES;
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    //初始化控制器内一些属性
    [self initConfig];
    
    [self setHeaderView];
    [self setFooterView];
    
    [self setToolBar];
    
    
    [self loadCommentData];
    
}

- (void)initConfig
{
    self.edgesForExtendedLayout = UIRectEdgeAll;//边缘扩展，就是当有navigationbar、tabbar和toolbar的时候，self.view的内容会铺满全屏，边缘的内容会被bar遮挡
    self.extendedLayoutIncludesOpaqueBars = YES;//在边缘扩展的时候，如果各种bar不是透明的话，会铺满全屏，跟上面的属性是配套使用的
    self.automaticallyAdjustsScrollViewInsets = NO;//自动布局view的时候，不会给scrollView加ContentInsets,在有bar的时候，系统默认是会给scrollView加ContentInsets的
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor colorWithWhite:0.926 alpha:1.000];
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 20);
    tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
}

#pragma mark - 设置TableView HeaderView
- (void)setHeaderView
{
    HQNewsDetailHeaderView *headerView = [[HQNewsDetailHeaderView alloc] init];
    headerView.news = self.news;
    headerView.width = self.tableView.width;
    CGFloat headerViewH = [headerView headerViewHeightWithNews:self.news];
    headerView.height = headerViewH;
    self.tableView.tableHeaderView = headerView;
    
}

- (void)setFooterView
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.height, 58)];
    footer.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.view.width, 10)];
    label.text = @"@版权所有，违版必究！";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithWhite:0.333 alpha:1.000];
    label.textAlignment = NSTextAlignmentCenter;
    
    [footer addSubview:label];
    
    self.tableView.tableFooterView = footer;
}

- (void)setToolBar
{
    HQNewsDetailToolBar *toolbar = [[HQNewsDetailToolBar alloc] init];
    toolbar.delegate = self;
    toolbar.width = self.view.width;
    toolbar.height = 56;
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}

- (void)loadCommentData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //获取指定资讯评论列表
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"message_id"] = self.news.news_id;
    
    [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/comment/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);

/*
        NSMutableArray *commentArray = responseObject[@"data"];
        NSError *error;
        //取出三个热门评论
        NSArray *array = [NSArray array];
        if ([responseObject[@"data"] count] > 2) {
            for (int i = 0; i < (commentArray.count - 1); i++)
                    {
                        for (int j = 0; j < commentArray.count - i - 1; j++)
                        {
                            if ([commentArray[j][@"attitude_count"] compare:commentArray[j+1][@"attitude_count"]] == NSOrderedDescending)
                            {
                                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                                tempDic = commentArray[j+1];
                                commentArray[j+1] = commentArray[j];
                                commentArray[j] = tempDic;
                            }
                        }
                    }
            
            NSLog(@"%@",commentArray);
            array = [HQNewsComment objectArrayWithKeyValuesArray:commentArray error:&error];
            for (int i = (int)commentArray.count; i < commentArray.count; i--) {
                [self.newComments addObject:array[i]];
            }
        }else
        {
            array = [HQNewsComment objectArrayWithKeyValuesArray:responseObject[@"data"] error:&error];
            [self.newComments addObjectsFromArray:array];
        }

*/
        NSError *error;
        self.allComments = (NSMutableArray *)[HQNewsComment objectArrayWithKeyValuesArray:responseObject[@"data"] error:&error];
        
        NSArray *array = [HQNewsComment objectArrayWithKeyValuesArray:responseObject[@"data"] error:&error];
        if (array.count >= 3) {
            for (int i = 0; i < 3; i++) {
                [self.newComments addObject:array[i]];
            }
        }else
        {
            [self.newComments addObjectsFromArray:array];
        }

        //刷新表格
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    if (self.allComments.count > 3) {
        return 2;
    }else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.newComments.count;
    }else
    {
        if (self.allComments.count > 3) {
            return 1;
        }else
        {
            return 0;
        }
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HQNewsCommentCell *cell = [HQNewsCommentCell cellWithTableView:tableView];
        cell.newsComment = self.newComments[indexPath.row];
        return cell;
    }else
    {
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"共有%lu条评论，点击查看更多", (unsigned long)self.allComments.count];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}


#pragma mark - Table view delegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }else
    {
        return YES;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HQNewsCommentCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HQNewsCommentCell" owner:nil options:nil] firstObject];
        CGFloat height = [cell cellHeightWithComment:self.newComments[indexPath.row]];
        return height;
    }else
    {
        return 44.0f;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.newComments.count > 0) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 55.5)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25.5, self.view.width, 20)];
            label.text = @"  最新评论:";
            label.textColor = [UIColor colorWithWhite:0.781 alpha:1.000];
            label.font = [UIFont systemFontOfSize:12];
            [headerView addSubview:label];
            
            headerView.backgroundColor = [UIColor whiteColor];
            
            return headerView;
        }else
        {
            return nil;
        }
    }else
    {
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.newComments.count > 0) {
        if (section == 0) {
            return 55.5f;
        }else
        {
            return 0.01f;
        }
    }else
    {
        return 0.01f;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.05f;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat differ = offsetY - self.offsetY;
    if(offsetY < 0)
    {
        return;
    }else if (differ > 0) {
            self.toolbar.hidden = YES;
    }else if (differ < 0)
    {
        if (offsetY >= scrollView.contentSize.height - self.view.height) {
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showToolbar) userInfo:nil repeats:NO];
        }else
        {
            self.toolbar.hidden = NO;
        }
        
    }
    self.offsetY = offsetY;
}

- (void)showToolbar
{
    self.toolbar.hidden = NO;
}

#pragma mark- Toolbar button delegate Action

- (void)clickedButton:(HQNewsDetailToolBarButtonType)buttonType
{
    switch (buttonType) {
        case HQNewsDetailToolBarButtonBack:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case HQNewsDetailToolBarButtonFavour:
        {
            
        }
            break;
        case HQNewsDetailToolBarButtonShare:
        {
            NSLog(@"sdfsaf");
        }
            break;
        
        case HQNewsDetailToolBarButtonComment:
        {
            [self pushViewController];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)pushViewController
{
    HQNewsCommentViewController *newsCommentViewController = [[HQNewsCommentViewController alloc] init];
    newsCommentViewController.comments = self.allComments;
    [self.navigationController pushViewController:newsCommentViewController animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

@end
