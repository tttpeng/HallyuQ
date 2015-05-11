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
#import "HQRecordViewController.h"
#import <AFNetworking.h>
@interface HQSendViewController ()<HQSendToolBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) HQTextView *sendView;
@property (nonatomic,strong) UITextField *titleView;
@property (nonatomic,strong) NSString *soundPath;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSound) name:@"recordEnd" object:nil];

}
-(void)setImage
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(5, 80, 60, 60);
    [self.sendView addSubview:imageView];
    self.imageView = imageView;
    
}


- (void)setSound
{
    if (!_soundPath) {
        NSString *pathDoc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [pathDoc stringByAppendingPathComponent:@"record.aac"];
        _soundPath = [NSString stringWithString:filePath];
        
    }
    return;
}
- (void)setTextView
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 40, 30)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"标题:";
    [self.view addSubview:titleLabel];
    //输入标题框
    UITextField *titleView = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, self.view.width-40, 30)];
    titleView.font = [UIFont systemFontOfSize:15];
    self.titleView = titleView;
    [self.view addSubview:self.titleView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(6, 30, self.view.width-12, 3)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    //发表内容文本框
    HQTextView *textView = [[HQTextView alloc] init];
    textView.alwaysBounceVertical = YES;
    textView.placeholder = @"吐槽一下吧...";
    textView.font = [UIFont systemFontOfSize:15];
    CGFloat textH = self.view.height - 2*(CGRectGetMaxY(self.titleView.frame)+64);
    //NSLog(@"%F]]]]]]]]]]]]]]]]]%F,%f",textH,self.view.height,self.view.height -textH);
    textView.frame = CGRectMake(6, CGRectGetMaxY(self.titleView.frame)+8, self.view.width-12,textH);
    self.sendView = textView;
    [self.view addSubview:self.sendView];
    //设置toolBar
    HQSendToolBar *toolBar = [[NSBundle mainBundle] loadNibNamed:@"HQSendToolBar" owner:nil options:nil][0];
    toolBar.frame = CGRectMake(0, 0, self.view.width, 37);
    //NSLog(@"%ld++++++++++++++",toolBar.subviews.count);
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

    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.titleView becomeFirstResponder];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.titleView endEditing:YES ];
}

- (void)send
{
    UIImage *image = self.imageView.image;
    NSData *imagedate = UIImagePNGRepresentation(image);
    NSString *base64image = [imagedate base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSData *dataSound = [NSData dataWithContentsOfFile:self.soundPath];
    NSString *soundString = [dataSound base64EncodedStringWithOptions:0];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"userid": @"149", @"title":self.titleView.text, @"content":self.sendView.text,@"image":base64image,@"sound":soundString};
        [manager POST:@"http://hanliuq.sinaapp.com/hlq_api/addthread/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

}



#pragma mark -- toolBar delegate


- (void)toolBar:(HQSendToolBar *)toolbar didClickedButton:(UIButton *)button
{
    switch (button.tag) {
        case 200:
            [self openEmoj];
            break;
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

- (void)openEmoj
{
    
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
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
