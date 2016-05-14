//
//  MYBBatchRequest.h
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/27.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYBRequest.h"

@interface MYBBatchRequest : NSObject

- (MYBBatchRequest *)initWithRequests:(NSArray *)requests;

- (void)stop;

- (void)addRequest:(MYBRequest *)request;

- (void)removeRequest:(MYBRequest *)request;

- (RACSignal *)batchCompletionSignal;

@end
