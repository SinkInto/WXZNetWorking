//
//  MYBBatchRequest.m
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/27.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "MYBBatchRequest.h"
#import "MYBNetWorkPrivite.h"
#import "MYBBatchRequestManager.h"

@implementation MYBBatchRequest {
    NSMutableArray *_requests;
}

- (MYBBatchRequest *)initWithRequests:(NSArray *)requests {
    self = [super init];
    if (self) {
        _requests = [NSMutableArray arrayWithArray:requests];
    }
    return self;
}

- (void)stop {
    [self clearRequest];
    [[MYBBatchRequestManager sharedInstance] removeBatchRequest:self];
}

- (void)addRequest:(MYBRequest *)request {
    if ([request isKindOfClass:[MYBRequest class]]) [_requests addObject:request];
}

- (void)removeRequest:(MYBRequest *)request {
    [_requests removeObject:request];
}

- (RACSignal *)batchCompletionSignal {
    [[MYBBatchRequestManager sharedInstance] addBatchRequest:self];
    NSMutableArray *signals = [NSMutableArray array];
    for (MYBRequest *request in _requests) {
        if ([request isKindOfClass:[MYBRequest class]]) {
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
    for (MYBRequest *request in _requests) {
        [request stop];
    }
}

- (void)dealloc {
    [self clearRequest];
}


@end
