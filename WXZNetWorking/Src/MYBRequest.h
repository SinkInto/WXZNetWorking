//
//  MYBRequest.h
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/26.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger , MYBRequestMethod) {
    MYBRequestMethodNone,
    MYBRequestMethodGet,
    MYBRequestMethodPost,
    MYBRequestMethodHead,
    MYBRequestMethodPut,
    MYBRequestMethodDelete,
    MYBRequestMethodPatch,
};

typedef NS_ENUM(NSInteger , MYBRequestSerializerType) {
    MYBRequestSerializerTypeHTTP = 0,
    MYBRequestSerializerTypeJSON,
};


@class MYBRequest;

typedef void(^MYBRequestCompletionBlock)(__kindof MYBRequest *request);
typedef void (^FormDataBlock)(id <AFMultipartFormData> formData);

@interface MYBRequest : NSObject

- (id)initWithRequestUrl:(NSString *)requestUrl params:(NSDictionary *)params;
- (id)initWithMethod:(MYBRequestMethod)method requestUrl:(NSString *)requestUrl params:(NSDictionary *)params;

@property (nonatomic, assign) MYBRequestMethod method;
@property (nonatomic, assign) MYBRequestSerializerType serializerType;

@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSString *cdnUrl;
@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, strong) NSDictionary *params;

//请求头
@property (nonatomic, strong) NSDictionary *requestHeaderFieldValueDictionary;

//存放服务器需要的 userName 和 密码 password @[@"userName",@"password"]
@property (nonatomic, strong) NSArray *requestAuthorizationHeaderFieldArray;

@property (nonatomic, strong) NSURLRequest *customRequest;

@property (nonatomic, assign) NSTimeInterval timeOutInterval;

@property (nonatomic, copy) FormDataBlock formDataBlock;

@property (nonatomic, copy) MYBRequestCompletionBlock successCompletionBlock;
@property (nonatomic, copy) MYBRequestCompletionBlock failureCompletionBlock;

@property (nonatomic, strong) id<RACSubscriber> subscriber;

@property (nonatomic, strong) NSURLSessionTask *sessionTask;
@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) NSError *responseError;

@property (nonatomic, assign, readonly) NSInteger responseCode;
@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;


/// append self to request queue
- (void)start;

/// remove self from request queue
- (void)stop;

/// block回调
- (void)startWithCompletionBlockWithSuccess:(MYBRequestCompletionBlock)success
                                    failure:(MYBRequestCompletionBlock)failure;

- (void)setCompletionBlockWithSuccess:(MYBRequestCompletionBlock)success
                              failure:(MYBRequestCompletionBlock)failure;

- (void)clearCompletionBlock;

@end



@interface MYBRequest (Signal)

- (RACSignal *)startWithCompletionSignal;
- (RACSignal *)completionSignal;

@end
