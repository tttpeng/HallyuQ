//
//  HQComment.h
//  HallyuQ
//
//  Created by qingyun on 15/3/28.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//
//usr_id = 149,
//floor_num = 23,
//sound_url = http://hallyu-hqllyumedia.stor.sinaapp.com/,
//usr_name = 杀马特大表哥,
//image_url = http://hallyu-hqllyumedia.stor.sinaapp.com/up/hlq/post/img/12.jpg,
//date = 2015-03-28 19:27:00,
//attitude_count = 0,
//content_text = 我们都很好啊，我是老韩！,
//avatar_img = http://hallyu-hqllyumedia.stor.sinaapp.com/
#import <Foundation/Foundation.h>

@interface HQComment : NSObject

@property (nonatomic,strong) NSString *usr_id;
@property (nonatomic,strong) NSString *usr_name;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *content_text;
@property (nonatomic,assign) NSInteger floor_num;
@property (nonatomic,strong) NSString *avatar_img;

@end
