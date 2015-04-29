//
//  HQNews.h
//  HallyuQ
//
//  Created by Ace on 15/3/29.
//  strongright (c) 2015年 HallyuQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQNews : NSObject

/**
 *  资讯ID
 */
@property (strong, nonatomic) NSString *news_id;

/**
 *  资讯标题
 */
@property (strong, nonatomic) NSString *titile;

/**
 *  主题
 */
@property (strong, nonatomic) NSString *theme;

/**
 *  作者
 */
@property (strong, nonatomic) NSString *author;

/**
 *  内容
 */
@property (strong, nonatomic) NSString *content;

/**
 *  新闻图片
 */
@property (strong, nonatomic) NSString *image;

/**
 *  日期
 */
@property (strong, nonatomic) NSString *date;

/**
 *  评论数
 */
@property (assign, nonatomic) NSInteger pl_num;

/**
 *  赞数
 */
@property (assign, nonatomic) NSInteger  zan_num;

/**
 *  已阅数
 */
@property (assign, nonatomic) NSInteger  views;



@end
