//
//  MYBBatchRequestManager.m
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/27.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "MYBBatchRequestManager.h"

@interface MYBBatchRequestManager()

@property (nonatomic, strong) NSMutableArray *requests;

@end

@implementation MYBBatchRequestManager

+ (MYBBatchRequestManager *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requests = [NSMutableArray array];
    }
    return self;
}

- (void)addBatchRequest:(MYBBatchRequest *)request {
    @synchronized(self) {
        [_requests addObject:request];
    }
}

- (void)removeBatchRequest:(MYBBatchRequest *)request {
    @synchronized(self) {
        [_requests removeObject:request];
    }
}

- (void)removeAllBatchRequests {
    @synchronized(self) {
        [_requests removeAllObjects];
    }
}

@end
