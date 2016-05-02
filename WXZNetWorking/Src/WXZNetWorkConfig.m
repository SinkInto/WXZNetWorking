//
//  MYBNetWorkConfig.m
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/26.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "WXZNetWorkConfig.h"

@implementation WXZNetWorkConfig {
    NSMutableArray *_paramFilters;
}

+ (WXZNetWorkConfig *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _paramFilters = [NSMutableArray array];
    }
    return self;
}

- (void)addParamFilter:(id<MYBParamsFilterProtocol>)filter {
    [_paramFilters addObject:filter];
}


- (NSArray *)urlFilters {
    return [_paramFilters copy];
}


@end
