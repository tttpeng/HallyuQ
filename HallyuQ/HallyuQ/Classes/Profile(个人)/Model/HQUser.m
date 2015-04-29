//
//  HQUser.m
//  HallyuQ
//
//  Created by iPeta on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQUser.h"
#import <MJExtension.h>

@implementation HQUser



+ (instancetype)currentUser
{
    static HQUser *currentUser;
        currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:HQAccountPath];

//    static dispatch_once_t pred;
//    dispatch_once(&pred, ^{
//        if ([NSKeyedUnarchiver unarchiveObjectWithFile:HQAccountPath]) {
//            //        }else
//        {
//            currentUser = [[self alloc] init];
//        }
//        
//    });
    return currentUser;
}

- (void)setProfile_image_url:(NSString *)profile_image_url
{

    NSString *imagePath = [NSString stringWithFormat:@"http://hallyu-hqllyumedia.stor.sinaapp.com/%@",[@"/smedia/up/hlq/user/6.jpg" substringFromIndex:8]];
    _profile_image_url = imagePath;

}

+ (void)loginout
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:HQAccountPath error:nil];
}
+ (void)loginSuccess:(NSString *)phoneNum pwdNum:(NSString *)pwdNum loginInfo:(HQUser *)userInfo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:phoneNum forKey:@"phone"];
    [user setObject:pwdNum forKey:@"passcode"];
    [user synchronize];
    
    [NSKeyedArchiver archiveRootObject:userInfo  toFile:HQAccountPath];
    
}

+ (void)saveWithUser:(HQUser*)user
{
    [NSKeyedArchiver archiveRootObject:user  toFile:HQAccountPath];
}


+(NSString *)replacedKeyFromPropertyName:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"mydescription"]) {
        return @"description";
    }
    return propertyName;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.icon_url forKey:@"icon_url"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.mydescription forKey:@"mydescription"];
    [aCoder encodeObject:self.favourites_count forKey:@"favourites_cout"];
    [aCoder encodeObject:self.followers_count forKey:@"followers_count"];

    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.icon_url = [aDecoder decodeObjectForKey:@"icon_url"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.mydescription = [aDecoder decodeObjectForKey:@"mydescription"];
        self.favourites_count = [aDecoder decodeObjectForKey:@"favourites_cout"];
        self.followers_count = [aDecoder decodeObjectForKey:@"followers_count"];
        

    }
    return self;
}
@end
