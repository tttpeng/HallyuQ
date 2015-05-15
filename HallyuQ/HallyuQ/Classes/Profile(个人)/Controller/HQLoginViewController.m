//
//  HQLoginViewController.m
//  HallyuQ
//
//  Created by iPeta on 15/3/26.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQLoginViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "HQUser.h"

@interface HQLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *pwdNum;

@end

@implementation HQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self testLogin];
    
}   


- (void)testLogin
{
//    测试普通登陆
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"phone":@"18600457706", @"passcode":@"111111"};
        // 设置请求格式
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置返回格式
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:@"http://hallyu.sinaapp.com/hlq_api/login/" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            NSString *str = [[responseObject objectForKey:@"errors"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
            NSLog(@"json: %@", responseObject);
            NSLog(@"str: %@", str);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

}

- (IBAction)login:(UIButton *)sender {
    //    测试普通登陆
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"phone":self.phoneNum.text, @"passcode":self.pwdNum.text};
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:@"http://hallyu.sinaapp.com/hlq_api/login/" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        NSLog(@"json: %@", responseObject);
        BOOL success = [responseObject[@"success"] boolValue];
        if (success) {
            HQUser *userInfo = [HQUser objectWithKeyValues:responseObject[@"data"]];
            HQUser *user = [HQUser currentUser];
            user.user_id = userInfo.user_id;

            [HQUser loginSuccess:self.phoneNum.text pwdNum:self.pwdNum.text loginInfo:userInfo];
            [MBProgressHUD hideHUD];
            [self back];
            [self.delegate loginViewControllerDidLoginSuccessWithUser:userInfo];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [MBProgressHUD showMessage:@"正在登陆...."];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
