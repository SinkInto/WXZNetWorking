//
//  MYBParamsFilter.m
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/27.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "WXZParamsFilter.h"
#import "WXZNetWorkPrivite.h"

@implementation WXZParamsFilter {
    NSDictionary *_params;
}

+ (WXZParamsFilter *)filterWithParams:(NSDictionary *)params {
    return [[self alloc] initWithParams:params];
}

- (id)initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _params = params;
    }
    return self;
}

- (NSDictionary *)filterOriginParams:(NSDictionary *)originParams {
    return [WXZNetWorkPrivite paramsWithOriginParams:originParams appendParams:_params];
}

@end
