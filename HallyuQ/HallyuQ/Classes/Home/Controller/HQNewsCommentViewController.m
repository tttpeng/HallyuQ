//
//  HQNewsCommentViewController.m
//  HallyuQ
//
//  Created by Ace on 15/4/3.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQNewsCommentViewController.h"
#import "HQNewsCommentCell.h"

@interface HQNewsCommentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@end

@implementation HQNewsCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    
    
    
    [self initConfig];
}

- (void)initConfig
{
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor colorWithWhite:0.926 alpha:1.000];
    tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (self.comments > 0) {
        return self.comments.count;
    }else
    {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.comments > 0) {
        HQNewsCommentCell *cell = [HQNewsCommentCell cellWithTableView:tableView];
        cell.newsComment = self.comments[indexPath.row];
        return cell;
    }else
    {
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = @"等你来发表看法哟~";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
}


#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.comments > 0) {
        HQNewsCommentCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HQNewsCommentCell" owner:nil options:nil] firstObject];
        CGFloat height = [cell cellHeightWithComment:self.comments[indexPath.row]];
        return height;
    }else
    {
        return 44.0f;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
@end
