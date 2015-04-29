//
//  HQPost.h
//  HallyuQ
//
//  Created by qingyun on 15/3/25.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//
//author = ,
//content = 今天星期一,明天星期二,后天星期三.,
//id = 39,
//image = http://hallyu-hqllyumedia.stor.sinaapp.com/,
//titile = Huohuohuo ,
//date = 2014-10-10 09:58:45
#import <Foundation/Foundation.h>
@class HQUser;
@interface HQPost : NSObject
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *titile;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,assign) NSInteger views;
@property (nonatomic,strong) NSString *sound_url;
@property (nonatomic,assign) NSInteger zan_num;


@property (nonatomic,strong) HQUser *user;
@end
