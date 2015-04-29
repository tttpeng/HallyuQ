//
//  ZYHttpTool.h
//  ZYWeibo
//
//  Created by Ace on 15/3/14.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYHttpTool : NSObject

+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void(^)(NSError *error))failure;

@end
