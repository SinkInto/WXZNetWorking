//
//  MYBBatchRequest.h
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/27.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXZRequest.h"

@interface WXZBatchRequest : NSObject

- (WXZBatchRequest *)initWithRequests:(NSArray *)requests;

- (void)stop;

- (void)addRequest:(WXZRequest *)request;

- (void)removeRequest:(WXZRequest *)request;

- (RACSignal *)batchCompletionSignal;

@end
