//
//  HQPostDetailViewController.m
//  HallyuQ
//
//  Created by qingyun on 15/3/28.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQPostDetailViewController.h"
#import <AFNetworking.h>
#import "HQComment.h"
#import "HQPostDetailCell.h"
#import <MJExtension.h>
#import "HQPostDetailHeaderView.h"
#import "HQPost.h"
#import "HQUser.h"
#import "HQPostDetailToolBar.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "HQPostDetailCommentBar.h"
#import <ShareSDK/ShareSDK.h>
@interface HQPostDetailViewController ()<HQPostDetailToolBar,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *commentArray;
@property (nonatomic,strong) HQPostDetailToolBar *toolBar;
@property (nonatomic,assign) NSInteger currentNum;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak)HQPostDetailCommentBar *commentBar;

@end

@implementation HQPostDetailViewController

-(instancetype)init{ 
    if (self = [super init]) {
        self.navigationItem.title = @"详情";
        self.navigationController.navigationBarHidden = NO;

    }
    return self;
}

-(NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] init];
	tableView.frame = self.view.bounds;
    tableView.height = kScreenHeight - 64 - 47;
    tableView.y = 64;
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	self.tableView = tableView;
	self.edgesForExtendedLayout = UIRectEdgeAll;
	self.extendedLayoutIncludesOpaqueBars = YES;
	self.automaticallyAdjustsScrollViewInsets = NO;

	
    [self setCommentPost];
    [self setHeaderView];
	[self setCommentBar];
	[self setToolbar];


}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.toolBar endEditing:YES ];
}


- (void)setToolbarNum
{
    int commentNUm = (int)self.commentArray.count;
    [self.toolBar.commentButton setTitle:[NSString stringWithFormat:@"%ld",(long)commentNUm] forState:UIControlStateNormal];
}

- (void)setHeaderView
{
    HQPostDetailHeaderView *headerView = [[HQPostDetailHeaderView alloc]init];
    headerView.width = self.tableView.width;
    headerView.post = self.post;
    CGFloat headerHeight = [headerView headerHeightWithPost:self.post];
    headerView.height = headerHeight ;
    self.tableView.tableHeaderView = headerView;
    UIView *footerView = [UIView new];
    self.tableView.tableFooterView = footerView;
}

- (void)setCommentBar
{
	HQPostDetailCommentBar *commentBar = [[HQPostDetailCommentBar alloc] init];
	commentBar.frame = CGRectMake(0, kScreenHeight - 47, kScreenWidth, 47);
	[self.view addSubview:commentBar];
    [commentBar.sendButton addTarget:self action:@selector(sendThreadComment) forControlEvents:UIControlEventTouchUpInside];
    [commentBar.keyButton addTarget:self action:@selector(keyboardDownClick) forControlEvents:UIControlEventTouchUpInside];
	self.commentBar = commentBar;

	
}

- (void)keyboardDownClick
{
    [self.view endEditing:YES];
}

//评论工具栏
- (void)setToolbar
{
    HQPostDetailToolBar *toolbar = [[HQPostDetailToolBar alloc] init];
    toolbar.frame = CGRectMake(0, kScreenHeight - 47, self.view.width, 47);
    self.currentNum = self.post.zan_num;
	
	[toolbar.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [toolbar.favoriteButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar.favoriteButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.currentNum] forState:UIControlStateNormal];
	[self.view addSubview:toolbar];
    toolbar.delegate = self;
    self.toolBar = toolbar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//键盘改变通知
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
	CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	
	CGRect keyboardFrame =  [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	CGFloat transfromY = keyboardFrame.origin.y - self.view.frame.size.height;
	
	[UIView animateWithDuration:duration  animations:^{
		self.commentBar.transform = CGAffineTransformMakeTranslation(0, transfromY);
	}];
}


- (void)commentButtonClick:(UIButton *)button
{
	[self.commentBar.textView becomeFirstResponder];
	
}

- (void)sendThreadComment
{
    if ([HQUser currentUser]) {
        if (self.commentBar.textView.text.length != 0) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *params = @{@"userid"  : [HQUser currentUser].user_id,
                                     @"bbs_id"  : self.post.ID,
                                     @"content" : self.commentBar.textView.text};
            [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/addpost/"
               parameters:params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                      self.commentBar.textView.text = nil;
                      _commentArray = nil;
                      [self setCommentPost];
                      [MBProgressHUD showSuccess:@"评论发送成功"];
                      [self.view endEditing:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD showError:@"评论发送失败，请重试"];
            }];
        }
    }
    else{
        [MBProgressHUD showError:@"请先登录~"];
    }
    
}

- (void)zanButtonClick:(UIButton *)button
{
    
    HQUser *user = [HQUser currentUser];
    
    if (user) {
        if (!button.selected) {
            button.selected = YES;
            int zanNum =   [button.titleLabel.text intValue];
            self.post.zan_num += 1;
            [button setTitle:[NSString stringWithFormat:@"%d",zanNum + 1] forState:UIControlStateNormal];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{@"message_id":self.post.ID,@"type":@"3"};
            [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/favor/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"json: %@", responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }else
        {
            return;
        }
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"亲~还没有登陆哟~" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }

    
}

- (void)keyboardWillShow:(NSNotification *)note
{
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
	NSLog(@"------>%@",NSStringFromCGRect(self.commentBar.frame));
    [UIView animateWithDuration:duration animations:^{
        CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
		NSLog(@"----->%@",NSStringFromCGRect(keyboardFrame));
        self.commentBar.transform = CGAffineTransformMakeTranslation(0, - keyboardFrame.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.toolBar.transform = CGAffineTransformIdentity;
    }];
    
}


- (void)setCommentPost
{
    //跟帖列表
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSLog(@"%@//////////////",self.post);
        NSDictionary *parameters = @{@"bbs_id":self.post.ID};
        [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/posts/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"json: %@", responseObject);
            NSArray *comArrary = [HQComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.commentArray addObjectsFromArray:comArrary];
            [self.tableView reloadData];
            [self setToolbarNum];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

}

#pragma mark - textField delegate


#pragma mark - toolbar delegate

-(void)toolbar:(HQPostDetailToolBar *)toolbar didClickedButton:(UIButton *)button
{
    switch (button.tag) {
        case 100:
            [self like];
            break;
        case 101:
            [self share];
            break;
        case 102:
            [self store];
            break;
        default:
            break;
    }
}

- (void)like
{
    
   // self.currentNum++;
    HQUser *user = [HQUser currentUser];
    if (user) {
       AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
      //NSLog(@"%@//////////////",self.post.ID);
       NSDictionary *parameters = @{@"bbs_id":self.post.ID,@"type":@"2"};
      [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/zan/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"json: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"亲~还没有登陆哟~" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
}

- (void)share
{
    HQUser *user = [HQUser currentUser];
    if (user) {
    id<ISSContent> publishContent = [ShareSDK content:
                                     self.post.content
                                       defaultContent:@"默认内容"
                                                image:nil
                                                title:self.post.titile
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条演示信息"
                                            mediaType:SSPublishContentMediaTypeNews];
     [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent
                     statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                         //可以根据回调提示用户。
                         if (state == SSResponseStateSuccess){
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                             [alert show];
                         }else if (state == SSResponseStateFail){
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                             [alert show];
                             
                         }
                         
                     }];

    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"亲~还没有登陆哟~" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }

}

- (void)store
{
    HQUser *user = [HQUser currentUser];
    if (user) {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSLog(@"%@//////////////",self.post.ID);
    NSDictionary *parameters = @{@"bbs_id":self.post.ID,@"user_id":user.user_id,@"action":@"1", @"type":@"2"};
    [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/collect/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"json: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"亲~还没有登陆哟~" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.commentArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        NSString *title = @"最新评论";
        return title;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HQPostDetailCell *cell = [HQPostDetailCell cellWithTableView:tableView];
    cell.comment = self.commentArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    MGSwipeButton *right1 = [MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"comment_tab"] backgroundColor:[UIColor colorWithRed:0.683 green:1.000 blue:0.313 alpha:1.000] callback:^BOOL(MGSwipeTableCell *sender) {
        [weakSelf tapLike];
        return YES;
    }];
    MGSwipeButton *right2 = [MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"内页-点赞-press"] backgroundColor:[UIColor colorWithRed:1.000 green:0.241 blue:0.786 alpha:1.000] callback:^BOOL(MGSwipeTableCell *sender) {
        [weakSelf tapLike];
        return YES;
    }];
    MGSwipeSettings *setting = [[MGSwipeSettings alloc] init];
    setting.transition = MGSwipeTransition3D;
    cell.rightSwipeSettings = setting;
    cell.rightButtons = @[right1,right2];
    return cell;
}

- (void)tapLike
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HQPostDetailCell *cell = [[NSBundle mainBundle] loadNibNamed:@"HQPostDetailCell" owner:nil options:nil][0];
    CGFloat cellheight = [cell cellHeightWithComment:self.commentArray[indexPath.row]];
    return cellheight;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
