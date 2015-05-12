//
//  HQPostDetailCommentBar.m
//  HallyuQ
//
//  Created by Tao Peng on 15/5/12.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQPostDetailCommentBar.h"

@implementation HQPostDetailCommentBar

-(instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self = [[NSBundle mainBundle] loadNibNamed:@"HQPostDetailCommentBar" owner:nil options:nil][0];
	}
	return self;
}

@end
