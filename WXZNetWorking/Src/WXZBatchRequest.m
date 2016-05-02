//
//  MYBBatchRequest.m
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/27.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "WXZBatchRequest.h"
#import "WXZNetWorkPrivite.h"
#import "WXZBatchRequestManager.h"

@implementation WXZBatchRequest {
    NSMutableArray *_requests;
}

- (WXZBatchRequest *)initWithRequests:(NSArray *)requests {
    self = [super init];
    if (self) {
        _requests = [NSMutableArray arrayWithArray:requests];
    }
    return self;
}

- (void)stop {
    [self clearRequest];
    [[WXZBatchRequestManager sharedInstance] removeBatchRequest:self];
}

- (void)addRequest:(WXZRequest *)request {
    if ([request isKindOfClass:[WXZRequest class]]) [_requests addObject:request];
}

- (void)removeRequest:(WXZRequest *)request {
    [_requests removeObject:request];
}

- (RACSignal *)batchCompletionSignal {
    [[WXZBatchRequestManager sharedInstance] addBatchRequest:self];
    NSMutableArray *signals = [NSMutableArray array];
    for (WXZRequest *request in _requests) {
        if ([request isKindOfClass:[WXZRequest class]]) {
            [signals addObject:request.startWithCompletionSignal];
        } else {
            MYBLog(@"Error, request item must be MYBRequest instance.");
        }
    }
    
    return [self signalWithSignals:signals];
}

- (RACSignal *)signalWithSignals:(NSArray *)signals {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[RACSignal combineLatest:signals] subscribeNext:^(id x) {
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        @strongify(self);
        return [RACDisposable disposableWithBlock:^ {
            [self stop];
        }];
    }];
}

- (void)clearRequest {
    for (WXZRequest *request in _requests) {
        [request stop];
    }
}

- (void)dealloc {
    [self clearRequest];
}


@end
