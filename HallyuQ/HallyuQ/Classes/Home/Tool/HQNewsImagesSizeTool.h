//
//  HQNewsImagesSizeTool.h
//  HallyuQ
//
//  Created by Ace on 15/4/2.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQNewsImagesSizeTool : NSObject


//调用后返回PNG格式图片CGSIze
-(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request;

//返回GIF格式图片的CGSize
- (CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request;

//返回JPG格式图片的CGSize
-(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request;


@end
