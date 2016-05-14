//
//  MYBRequestManager.h
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/26.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYBRequest.h"

@interface MYBRequestManager : NSObject

+ (MYBRequestManager *)sharedInstance;

- (void)addRequest:(MYBRequest *)request;

- (void)cancelRequest:(MYBRequest *)request;

- (void)cancelAllRequests;

/// 根据request和networkConfig构建url
- (NSString *)buildRequestUrl:(MYBRequest *)request;

@end
