//
//  HQPostController.m
//  HallyuQ
//
//  Created by qingyun on 15/3/22.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQPostController.h"
#import "HQSendViewController.h"
#import "HQNavigationViewController.h"
@interface HQPostController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation HQPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    float j = 0.f;
    for (int i = 0; i<self.buttons.count; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(j * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIButton *button = self.buttons[i];
            CGRect frame = button.frame;
            
            UILabel *label = self.labels[i];
            CGRect labelFrame = label.frame;
            
            button.frame = CGRectOffset(frame, 0, self.view.frame.size.height - frame.origin.y);
            label.frame = CGRectOffset(labelFrame, 0, self.view.frame.size.height - frame.origin.y);
            button.hidden = NO;
            label.hidden = NO;
            [UIView animateWithDuration:.25f animations:^{
                button.frame = CGRectOffset(frame, 0, -20);
                label.frame = CGRectOffset(labelFrame, 0, -20);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.1f animations:^{
                    button.frame = frame;
                    label.frame = labelFrame;
                }];
            }];
            
        });
        j+= 0.05;
    }
}

- (IBAction)giveup:(id)sender {
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navHidden" object:nil];
}
- (IBAction)buttonClicked:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
        {
            HQSendViewController *send = [[HQSendViewController alloc] init];
            //HQNavigationViewController *sendVC = [[HQNavigationViewController alloc] initWithRootViewController:send];
            [self.navigationController pushViewController:send animated:YES];
            
        }
            break;
        case 2:
        {
            UIImagePickerController *photoVC = [[UIImagePickerController alloc] init];
            photoVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            photoVC.delegate = self;
            [self presentViewController:photoVC animated:YES completion:nil];
        }
            break;
        case 3:
        {
        
            UIImagePickerController *photoVC = [[UIImagePickerController alloc] init];
            photoVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            photoVC.delegate = self;
            [self presentViewController:photoVC animated:YES completion:nil];
        }
            
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    HQSendViewController *sendVC = [[HQSendViewController alloc] init];
    sendVC.imageView.image = image;
    [self.navigationController pushViewController:sendVC animated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
