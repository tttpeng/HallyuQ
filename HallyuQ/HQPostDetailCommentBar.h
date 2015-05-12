//
//  HQPostDetailCommentBar.h
//  HallyuQ
//
//  Created by Tao Peng on 15/5/12.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQPostDetailCommentBar : UIView
-(instancetype)initWithFrame:(CGRect)frame;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *keyButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@end
