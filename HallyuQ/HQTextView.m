//
//  HQTextView.m
//  HallyuQ
//
//  Created by qingyun on 15/3/25.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQTextView.h"

@interface HQTextView()

@property (nonatomic,strong) UILabel *placeholderLable;

@end

@implementation HQTextView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *lable = [[UILabel alloc] init];
        lable.textColor = [UIColor colorWithWhite:0.518 alpha:1.000];
        lable.font = self.font;
        lable.backgroundColor = [UIColor clearColor];
        [self insertSubview:lable atIndex:0];
        lable.hidden = YES;
        self.placeholderLable = lable;
        self.backgroundColor = [UIColor colorWithRed:1.000 green:0.653 blue:0.934 alpha:1.000];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

- (void)textDidChanged
{
    if (self.text.length) {
        self.placeholderLable.hidden = YES;
    }else
    {
        self.placeholderLable.hidden = NO;
    }
}

- (void)setFont:(UIFont *)font
{
    self.placeholderLable.font = font;

    [super setFont:font];
}


-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    self.placeholderLable.text = placeholder;
    if (placeholder) {
        self.placeholderLable.hidden = NO;
        CGFloat placeholderX = 7;
        CGFloat placeholderY = 7;
        NSLog(@"%@===============",placeholder);
        CGSize placeLabelSize = [placeholder sizeWithAttributes:@{NSFontAttributeName:self.placeholderLable.font}];
        self.placeholderLable.frame = CGRectMake(placeholderX, placeholderY, placeLabelSize.width, placeLabelSize.height);
    }else
    {
        self.placeholderLable.hidden = YES;
    }
}
@end
