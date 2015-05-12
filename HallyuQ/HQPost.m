//
//  HQPost.m
//  HallyuQ
//
//  Created by qingyun on 15/3/25.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQPost.h"
#import <MJExtension.h>

@implementation HQPost

+ (NSString *)replacedKeyFromPropertyName:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"ID"]) {
        return @"id";
    }
    return propertyName;
}

- (NSString *)date
{
    return @"一个月前";
}
@end
