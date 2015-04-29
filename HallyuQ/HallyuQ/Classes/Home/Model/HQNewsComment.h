//
//  HQNewsComment.h
//  HallyuQ
//
//  Created by Ace on 15/4/2.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQNewsComment : NSObject

/**
 *  评论楼层
 */
@property (assign, nonatomic) int floor_num;

/**
 *  用户ID
 */
@property (assign, nonatomic) int user_id;

/**
 *  用户名
 */
@property (copy, nonatomic) NSString *usr_name;

/**
 *  发表评论时间
 */
@property (copy, nonatomic) NSString *date;

/**
 *  点赞数
 */
@property (assign, nonatomic) int attitude_count;

/**
 *  评论内容
 */
@property (copy, nonatomic) NSString *content_text;

/**
 *  用户头像地址
 */
@property (copy, nonatomic) NSString *avatar_img;




@end
