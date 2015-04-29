//
//  HQUser.h
//  HallyuQ
//
//  Created by iPeta on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#define HQAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.data"]

#import <Foundation/Foundation.h>

@interface HQUser : NSObject<NSCoding>


@property (nonatomic, copy)NSString *nickname;

@property (nonatomic, copy)NSString *age;

@property (nonatomic, copy)NSString *gender;

@property (nonatomic, copy)NSString *icon_url;

@property (nonatomic,copy) NSString *profile_image_url;

@property (nonatomic, copy)NSString *address;

@property (nonatomic, copy)NSString *user_id;

@property (nonatomic, copy)NSString *uid;

@property (nonatomic, copy)NSString *mydescription;

@property (nonatomic, copy)NSString *favourites_count;

@property (nonatomic, copy)NSString *followers_count;

+ (instancetype)currentUser;
+ (void)loginSuccess:(NSString *)phoneNum pwdNum:(NSString *)pwdNum loginInfo:(HQUser *)userInfo;
+ (void)loginout;
+ (void)saveWithUser:(HQUser*)user;
@end
