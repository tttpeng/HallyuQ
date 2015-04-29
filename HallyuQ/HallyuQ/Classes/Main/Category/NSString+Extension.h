//
//  NSString+Extension.h
//  ZYWeibo
//
//  Created by Ace on 15/3/10.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
@end
