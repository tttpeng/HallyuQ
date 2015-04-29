//
//  HQNewsComment.m
//  HallyuQ
//
//  Created by Ace on 15/4/2.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQNewsComment.h"
#import "HQNewsDateTool.h"

@implementation HQNewsComment

- (NSString *)date
{
    return [HQNewsDateTool calculateWithDate:_date];
}

@end
