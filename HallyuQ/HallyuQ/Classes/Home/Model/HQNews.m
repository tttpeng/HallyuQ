//
//  HQNews.m
//  HallyuQ
//
//  Created by Ace on 15/3/29.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQNews.h"
#import "HQNewsDateTool.h"

@implementation HQNews

- (NSString *)date
{
    return [HQNewsDateTool calculateWithDate:_date];
}
@end
