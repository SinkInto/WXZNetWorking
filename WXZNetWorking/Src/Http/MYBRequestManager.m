//
//  MYBRequestManager.m
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/26.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "MYBRequestManager.h"
#import "MYBNetWorkPrivite.h"
#import "MYBNetWorkConfig.h"
#import "MYBRequest.h"

@implementation MYBRequestManager {
    AFHTTPSessionManager *_manager;
    MYBNetWorkConfig *_config;
    NSMutableDictionary *_requestsRecord;
}


+ (MYBRequestManager *)sharedInstance {
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
        _config = [MYBNetWorkConfig sharedInstance];
        _manager = [AFHTTPSessionManager manager];
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager.operationQueue.maxConcurrentOperationCount = 5;
    }
    return self;
}

- (void)addRequest:(MYBRequest *)request {
    
    NSString *url = [self buildRequestUrl:request];
    id params = [self buildRequestParams:request];
    if (request.serializerType == MYBRequestSerializerTypeHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.serializerType == MYBRequestSerializerTypeJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    request.session = _manager.session;
    
    //服务器账号和密码
    NSArray *requestAuthorizationHeaderFieldArray = request.requestAuthorizationHeaderFieldArray;
    if (requestAuthorizationHeaderFieldArray != nil) {
        [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)requestAuthorizationHeaderFieldArray.firstObject password:(NSString *)requestAuthorizationHeaderFieldArray.lastObject];
    }
    
    //请求头
    NSDictionary *requestHeaderFieldValueDictionary = request.requestHeaderFieldValueDictionary;
    if (requestHeaderFieldValueDictionary != nil) {
        for (id httpHeaderField in requestHeaderFieldValueDictionary.allKeys) {
            id value = requestHeaderFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            } else {
                MYBLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
    _manager.requestSerializer.timeoutInterval = [request timeOutInterval];
    
    if (request.customRequest) {
        request.sessionTask = [_manager dataTaskWithRequest:request.customRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            [self handleRequestResultWithTask:nil resopnseObject:responseObject error:error];
        }];
    } else {
        switch (request.method) {
            case MYBRequestMethodGet:
            {
                request.sessionTask = [_manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleRequestResultWithTask:task resopnseObject:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleRequestResultWithTask:task resopnseObject:nil error:error];
                }];
            }
                break;
            
            case MYBRequestMethodPut:
            {
                request.sessionTask = [_manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleRequestResultWithTask:task resopnseObject:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleRequestResultWithTask:task resopnseObject:nil error:error];
                }];
            }
                break;
                
            case MYBRequestMethodPost:
            {
                if (!request.formDataBlock)
                    request.sessionTask = [_manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        [self handleRequestResultWithTask:task resopnseObject:responseObject error:nil];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [self handleRequestResultWithTask:task resopnseObject:nil error:error];
                    }];
                else
                    request.sessionTask = [_manager POST:url parameters:params constructingBodyWithBlock:request.formDataBlock progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleRequestResultWithTask:task resopnseObject:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleRequestResultWithTask:task resopnseObject:nil error:error];
                }];
            }
                break;
                
            case MYBRequestMethodDelete:
            {
                request.sessionTask = [_manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleRequestResultWithTask:task resopnseObject:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleRequestResultWithTask:task resopnseObject:nil error:error];
                }];
            }
                break;
                
            case MYBRequestMethodHead:
            {
                request.sessionTask = [_manager HEAD:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task) {
                    [self handleRequestResultWithTask:task resopnseObject:nil error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleRequestResultWithTask:task resopnseObject:nil error:error];
                }];
            }
                break;
                
            case MYBRequestMethodPatch:
            {
                request.sessionTask = [_manager PATCH:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleRequestResultWithTask:task resopnseObject:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleRequestResultWithTask:task resopnseObject:nil error:error];
                }];
            }
                break;
                
            default:
                break;
        }
        [self addOperation:request];
    }
    
}

- (void)cancelRequest:(MYBRequest *)request {
    [request.sessionTask cancel];
    [self removeOperation:request];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        MYBRequest *request = copyRecord[key];
        [request stop];
    }
}

/// 根据request和networkConfig构建url
- (NSString *)buildRequestUrl:(MYBRequest *)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    
    NSString *baseUrl;
    if ([request cdnUrl]) {
        if ([request cdnUrl].length > 0) {
            baseUrl = [request cdnUrl];
        } else {
            baseUrl = [_config cdnUrl];
        }
    } else {
        if ([request baseUrl].length > 0) {
            baseUrl = [request baseUrl];
        } else {
            baseUrl = [_config baseUrl];
        }
    }
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

- (NSDictionary *)buildRequestParams:(MYBRequest *)request {
    NSDictionary *params = request.params;
    if (params == nil) return params;
    NSArray *filters = [_config paramFilters];
    for (id<MYBParamsFilterProtocol> f in filters) {
        params = [f filterOriginParams:params];
    }
    return params;
}

- (void)handleRequestResultWithTask:(NSURLSessionDataTask *)task resopnseObject:(id)responseObject error:(NSError *)error {
    NSString *key = [self requestHashKey:task];
    MYBRequest *_request = _requestsRecord[key];
    _request.responseObject = responseObject;
    _request.responseError = error;
    
    if (error) {
        if (_request.failureCompletionBlock) _request.failureCompletionBlock(_request);
        if (_request.subscriber) [_request.subscriber sendError:_request.responseError];
    } else {
        if (_request.successCompletionBlock) _request.successCompletionBlock(_request);
        if (_request.subscriber) {
            [_request.subscriber sendNext:_request];
            [_request.subscriber sendCompleted];
        }
    }
    
    [self removeOperation:_request];
    [_request clearCompletionBlock];
}


- (NSString *)requestHashKey:(NSURLSessionTask *)task {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[task hash]];
    return key;
}

- (void)addOperation:(MYBRequest *)request {
    if (request.sessionTask != nil) {
        NSString *key = [self requestHashKey:request.sessionTask];
        @synchronized(self) {
            _requestsRecord[key] = request;
        }
    }
}

- (void)removeOperation:(MYBRequest *)request {
    NSString *key = [self requestHashKey:request.sessionTask];
    @synchronized(self) {
        [_requestsRecord removeObjectForKey:key];
    }
    MYBLog(@"Request queue size = %lu", (unsigned long)[_requestsRecord count]);
}


@end
