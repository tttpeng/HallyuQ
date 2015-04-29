//
//  HQDbTool.m
//  HallyuQ
//
//  Created by iPeta on 15/4/3.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQDbTool.h"
#import <FMDB.h>

static FMDatabase * _db;
@implementation HQDbTool

+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"hallyuquan.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_news (id integer PRIMARY KEY, news blob NOT NULL,comment blob, idstr text NOT NULL UNIQUE);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_theard (id integer PRIMARY KEY, theard blob NOT NULL, comment blob, idstr text NOT NULL UNIQUE);"];
}


+ (NSArray *)newsWithParamas:(NSDictionary *)paramas
{
    NSString *sql = nil;
    if (paramas[@"since_id"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_news WHERE idstr < %@ ORDER BY idstr DESC LIMIT 20;",paramas[@"since_id"]];
    }else if(paramas[@"max_id"])
    {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_news WHERE idstr > %@ ORDER BY idstr DESC LIMIT 20;",paramas[@"max_id"]];
    }else
    {
        sql = @"SELECT * FROM t_news ORDER BY idstr DESC LIMIT 20;";
    }
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *newses = [NSMutableArray array];
    while (set.next) {
        NSData *newsData = [set objectForColumnName:@"news"];
        NSDictionary *news = [NSKeyedUnarchiver unarchiveObjectWithData:newsData];
        [newses addObject:news];
    }
    return newses;
}

+ (NSArray *)threadsWithParamas:(NSDictionary *)paramas
{
    NSString *sql = nil;
    if (paramas[@"since_id"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_theard WHERE idstr < %@ ORDER BY idstr DESC LIMIT 20;",paramas[@"since_id"]];
    }else if(paramas[@"max_id"])
    {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_theard WHERE idstr > %@ ORDER BY idstr DESC LIMIT 20;",paramas[@"max_id"]];
    }else
    {
        sql = @"SELECT * FROM t_theard ORDER BY idstr DESC LIMIT 20;";
    }
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *threads = [NSMutableArray array];
    while (set.next) {
        NSData *threadData = [set objectForColumnName:@"theard"];
        NSDictionary *thread = [NSKeyedUnarchiver unarchiveObjectWithData:threadData];
        [threads addObject:thread];
    }
    return threads;
    
}

+ (NSArray *)newsCommentsWithnewsId:(NSString *)news_id
{
    NSString *sql = nil;
    sql =[NSString stringWithFormat:@"SELECT comment FROM t_news WHERE idstr=%@;",news_id]    ;
    
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *comments = [NSMutableArray array];
    while (set.next) {
        if(![set columnIsNull:@"comment"])
        {
            NSData *threadData = [set objectForColumnName:@"comment"];
         [comments addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:threadData]];
            
        }
    }
    return comments;
}

+ (NSArray *)threadCommentsWithThreadId:(NSString *)thread_id{
    NSString *sql = nil;
    sql =[NSString stringWithFormat:@"SELECT comment FROM t_theard WHERE idstr=%@;",thread_id];
    
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *comments = [NSMutableArray array];
    while (set.next) {
        if (![set columnIsNull:@"comment"]) {

        NSData *threadData = [set objectForColumnName:@"comment"];
         [comments addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:threadData]];
        }
    }
    return comments;
}



+ (void)saveNewsComment:(NSArray *)comments{
    
    if (comments) {
        NSData *newsData = [NSKeyedArchiver archivedDataWithRootObject:comments];
        [_db executeUpdateWithFormat:@"UPDATE t_news SET comment=%@ WHERE idstr=%@",newsData,comments[0][@"news_id"]];
    }
    
}

+ (void)saveThreadComment:(NSArray *)comments{
    
    if (comments) {
        NSData *commentData = [NSKeyedArchiver archivedDataWithRootObject:comments];
        [_db executeUpdateWithFormat:@"UPDATE t_theard SET comment=%@ WHERE idstr=%@",commentData,comments[0][@"thread_id"]];
    }
}

+ (void)saveNews:(NSArray *)newses
{
    for (NSDictionary *news  in newses) {
        NSData *newsData = [NSKeyedArchiver archivedDataWithRootObject:news];
        [_db executeUpdateWithFormat:@"INSERT INTO t_news(news, idstr) VALUES (%@, %@);",newsData,news[@"news_id"]];
    }
}


+ (void)saveTheard:(NSArray *)theards
{
    
    for (NSDictionary *theard  in theards) {
        NSData *newsData = [NSKeyedArchiver archivedDataWithRootObject:theard];
        [_db executeUpdateWithFormat:@"INSERT INTO t_theard(theard, idstr) VALUES (%@, %@);",newsData,theard[@"id"]];
    }
}

@end
