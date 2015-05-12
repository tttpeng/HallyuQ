//
//  HQSendViewController.m
//  HallyuQ
//
//  Created by qingyun on 15/3/22.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQSendViewController.h"
#import "HQPostController.h"
#import "HQNavigationViewController.h"
#import "HQTextView.h"
#import "HQSendToolBar.h"
#import "HQUser.h"
#import "HQRecordViewController.h"
#import <AFNetworking.h>
@interface HQSendViewController ()<HQSendToolBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) HQTextView  *sendView;
@property (nonatomic,strong) UITextField *titleView;
@property (nonatomic,strong) NSString    *soundPath;
@property (nonatomic,weak  ) UIButton    *deletaButton;

@end

@implementation HQSendViewController

-(instancetype)init
{
    if (self = [super init]) {
        
        [self setNavication];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTextView];
    [self setImage];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;

}
-(void)setImage
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(5, 100, 80, 80);
    [self.sendView addSubview:imageView];
    self.imageView = imageView;
    
    UIButton *button = [[UIButton alloc] init];
    button.width  = 20;
    button.height = 20;
    button.center = CGPointMake(85, 100);
    button.hidden = YES;
    [button setImage:[UIImage imageNamed:@"发表-缩略图-删除"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    self.deletaButton = button;
    [self.sendView addSubview:button];
    

}

- (void)deleteImage
{
    self.imageView.image = nil;
    self.deletaButton.hidden = YES;
}

- (void)setTextView
{
    
    //输入标题框
    UITextField *titleView = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.view.width - 20, 45)];
    titleView.placeholder = @"还没有写标题！";
    titleView.font        = [UIFont systemFontOfSize:17];
    self.titleView        = titleView;
    [self.view addSubview:self.titleView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, self.view.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.867 alpha:1.000];
    [self.view addSubview:lineView];
    
    //发表内容文本框
    HQTextView *textView          = [[HQTextView alloc] init];
    textView.alwaysBounceVertical = YES;
    textView.placeholder          = @"请输入帖子内容！";
    textView.font                 = [UIFont systemFontOfSize:17];
    CGFloat textH                 = self.view.height - 2 * (CGRectGetMaxY(self.titleView.frame)+64);
    textView.frame                = CGRectMake(6,
                                               CGRectGetMaxY(self.titleView.frame)+8,
                                               self.view.width - 12,textH);
    textView.backgroundColor      = [UIColor whiteColor];
    textView.delegate = self;
    self.sendView                 = textView;
    [self.view addSubview:self.sendView];
    //设置toolBar
    HQSendToolBar *toolBar = [[NSBundle mainBundle] loadNibNamed:@"HQSendToolBar" owner:nil options:nil][0];
    toolBar.frame = CGRectMake(0, 0, self.view.width, 37);
    self.sendView.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 37)];
    toolBar.backgroundColor = [UIColor whiteColor];
    toolBar.delegate = self;
    [self.sendView.inputAccessoryView addSubview:toolBar];
    
}
-(void)setNavication
{
    
    //HQNavigationViewController *sendVC = [[HQNavigationViewController alloc] initWithRootViewController:self];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(quitSend)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"饭语一下";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

- (void)quitSend
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出编辑" message:@"退出后帖子内容将丢失，是否退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.titleView becomeFirstResponder];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)send
{
    
    if (self.titleView.text.length == 0) {
        [MBProgressHUD showError:@"请输入标题"];
        return;
    }
    if (self.sendView.text.length == 0) {
        [MBProgressHUD showError:@"请输入帖子内容"];
        return;
    }
    
    UIImage *image = self.imageView.image;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"userid": [HQUser currentUser].user_id, @"title":self.titleView.text, @"content":self.sendView.text}];
    if (image) {
        NSData *imagedate = UIImagePNGRepresentation(image);
        NSString *base64image = [imagedate base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [params setValue:base64image forKey:@"image"];
    }
    [MBProgressHUD showMessage:@"正在发表请稍后"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/addthread/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"发表成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUD];
            NSLog(@"Error: %@", error);
        }];

}



#pragma mark -- toolBar delegate


- (void)toolBar:(HQSendToolBar *)toolbar didClickedButton:(UIButton *)button
{
    switch (button.tag) {
        case 201:
            [self openPicture];
            break;
        case 202:
            [self openRecoder];
            break;
        case 203:
            [self delete];
            break;
        default:
            break;
    }
}

- (void)openPicture
{
    UIImagePickerController *picVC = [[UIImagePickerController alloc] init];
    picVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picVC.delegate = self;
    [self presentViewController:picVC animated:YES completion:nil];
}

- (void)openRecoder
{
    HQRecordViewController *recordVC = [[HQRecordViewController alloc] init];
    [self presentViewController:recordVC animated:YES completion:nil];
}

- (void)delete
{
    [self.sendView endEditing:YES ];

}

#pragma mark -- imagePicker delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    self.deletaButton.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
