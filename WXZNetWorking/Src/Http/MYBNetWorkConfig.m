//
//  MYBNetWorkConfig.m
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/26.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "MYBNetWorkConfig.h"

@implementation MYBNetWorkConfig {
    NSMutableArray *_paramFilters;
}

+ (MYBNetWorkConfig *)sharedInstance {
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

- (id<MYBParamsFilterProtocol>)filterAtIndex:(NSInteger)index {
    if (index >= _paramFilters.count) {
        NSLog(@"下标超出范围");
        return nil;
    }
    return [_paramFilters objectAtIndex:index];
}

- (NSInteger)indexOfFilter:(id<MYBParamsFilterProtocol>)filter {
    NSAssert(filter, @"filter 不能为空");
    return [_paramFilters indexOfObject:filter];
}

- (void)replaceParamFiltersAtIndex:(NSInteger)index withParamFilters:(id<MYBParamsFilterProtocol>)filter {
    if (!filter) return;
    [_paramFilters replaceObjectAtIndex:index withObject:filter];
}


- (NSArray *)urlFilters {
    return [_paramFilters copy];
}


@end
