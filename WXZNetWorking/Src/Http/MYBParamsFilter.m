//
//  MYBParamsFilter.m
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/27.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "MYBParamsFilter.h"
#import "MYBNetWorkPrivite.h"

@implementation MYBParamsFilter {
    NSMutableDictionary *_params;
}

+ (MYBParamsFilter *)filterWithParams:(NSDictionary *)params {
    return [[self alloc] initWithParams:params];
}

- (id)initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _params = [params mutableCopy];
    }
    return self;
}

- (void)setFilterValue:(id)filterValue forKey:(NSString *)key {
    NSAssert(key, @"key不能为空");
    filterValue = filterValue ? filterValue : @"";
    [_params setValue:filterValue forKey:key];
}

- (NSDictionary *)filterOriginParams:(NSDictionary *)originParams {
    return [MYBNetWorkPrivite paramsWithOriginParams:originParams appendParams:_params];
}

@end
