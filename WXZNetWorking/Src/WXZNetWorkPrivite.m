//
//  MYBNetWorkPrivite.m
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/26.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "WXZNetWorkPrivite.h"

void MYBLog(NSString *format, ...) {
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

@implementation WXZNetWorkPrivite

+ (NSDictionary *)paramsWithOriginParams:(NSDictionary *)originParams appendParams:(NSDictionary *)params {
    if (originParams == nil) return nil;
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionary];
    [mutableParams setValue:originParams forKey:@"body"];
    [mutableParams setValue:params forKey:@"head"];
    return mutableParams;
}

@end
