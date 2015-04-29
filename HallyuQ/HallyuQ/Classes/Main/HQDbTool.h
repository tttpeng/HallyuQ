//
//  HQDbTool.h
//  HallyuQ
//
//  Created by iPeta on 15/4/3.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQDbTool : NSObject


/**
 *  从数据库获取字典数组
 *
 *  @param paramas since_id或者max_id 不传参数则是数据库最新的20条数据
 *
 *  @return 装有字典的数组
 */
+ (NSArray *)newsWithParamas:(NSDictionary *)paramas;

/**
 *  从数据库获取字典数组
 *
 *  @param paramas since_id或者max_id 不传参数则是数据库最新的20条数据
 *
 *  @return 装有字典的数组
 */
+ (NSArray *)threadsWithParamas:(NSDictionary *)paramas;

/**
 *  返回评论字典数组
 *
 *  @param news_id 新闻id
 *
 *  @return 字段数组
 */
+ (NSArray *)newsCommentsWithnewsId:(NSString *)news_id;

/**
 *  返回评论字典数组
 *
 *  @param news_id 帖子id
 *
 *  @return 字典数组
 */
+ (NSArray *)threadCommentsWithThreadId:(NSString *)thread_id;


/**
 *  保存到数据库
 *
 *  @param comments 字典数组
 */
+ (void)saveNewsComment:(NSArray *)comments;

/**
 *  保存到数据库
 *
 *  @param comments 字典数组
 */
+ (void)saveThreadComment:(NSArray *)comments;


/**
 *  保存到数据库
 *
 *  @param comments 字典数组
 */
+ (void)saveNews:(NSArray *)newses;

/**
 *  保存到数据库
 *
 *  @param comments 字典数组
 */
+ (void)saveTheard:(NSArray *)theards;
@end
