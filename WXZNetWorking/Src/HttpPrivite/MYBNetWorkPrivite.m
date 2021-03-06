//
//  MYBNetWorkPrivite.m
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/26.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "MYBNetWorkPrivite.h"
#import "MYBModel.h"

void MYBLog(NSString *format, ...) {
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

@implementation MYBNetWorkPrivite

+ (NSDictionary *)paramsWithOriginParams:(NSDictionary *)originParams appendParams:(NSDictionary *)params {
    if (originParams == nil) return nil;
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionary];
    [mutableParams setValue:originParams forKey:@"body"];
    [mutableParams setValue:params forKey:@"head"];
    return mutableParams;
}


//+ (id)handelResponseObject:(id)responseObject associatedClass:(Class)aclass {
//    if (![aclass isSubclassOfClass:[MYBHttpModel class]]) {
//        return responseObject;
//    }
//    if (responseObject) {
//        return [aclass jsonToModel:responseObject[@"body"]];
//    }
//    return responseObject;
//}

@end
