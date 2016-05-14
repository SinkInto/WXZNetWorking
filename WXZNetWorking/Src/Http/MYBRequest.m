//
//  MYBRequest.m
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/26.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "MYBRequest.h"
#import "MYBRequestManager.h"
#import "MYBNetWorkConfig.h"

#define TIME_OUT 15
#define UPLOAD_IMAGE_TIME_OUT 60

@interface MYBRequest ()


@end

@implementation MYBRequest

- (id)initWithRequestUrl:(NSString *)requestUrl params:(NSDictionary *)params {
    return [self initWithMethod:MYBRequestMethodPost requestUrl:requestUrl params:params];
}

- (id)initWithMethod:(MYBRequestMethod)method requestUrl:(NSString *)requestUrl params:(NSDictionary *)params {
    self = [self init];
    if (self) {
        self.method = method;
        self.requestUrl = requestUrl;
        self.params = params;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.serializerType = MYBRequestSerializerTypeJSON;
    }
    return self;
}

- (void)start {
  [[MYBRequestManager sharedInstance] addRequest:self];
}

/// remove self from request queue
- (void)stop {
    [[MYBRequestManager sharedInstance] cancelRequest:self];
}

- (void)startWithCompletionBlockWithSuccess:(MYBRequestCompletionBlock)success
                                    failure:(MYBRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(MYBRequestCompletionBlock)success
                              failure:(MYBRequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (MYBRequestMethod)method {
    return _method == MYBRequestMethodNone ? MYBRequestMethodPost : _method;
}

- (NSTimeInterval)timeOutInterval {
    return _timeOutInterval == 0 ? TIME_OUT : _timeOutInterval;
}

- (void)setResponseObject:(id)responseObject {
    _responseObject = responseObject;
    if (self.associatedClass) {
        _responseObject = [self.associatedClass httpResponseObject:responseObject];
    }
}

- (NSDictionary *)responseHeaders {
    return self.response.allHeaderFields;
}

- (NSInteger)responseCode {
    return self.response.statusCode;
}

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.sessionTask.response;
}


@end


@implementation MYBRequest (Signal)

- (RACSignal *)startWithCompletionSignal {
    [self start];
    return [self completionSignal];
}

- (RACSignal *)completionSignal {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        self.subscriber = subscriber;
        return [RACDisposable disposableWithBlock:^{
            [self stop];
        }];
    }];
}

@end
