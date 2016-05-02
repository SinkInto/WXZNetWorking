//
//  MYBRequestManager.h
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/26.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXZRequest.h"

@interface WXZRequestManager : NSObject

+ (WXZRequestManager *)sharedInstance;

- (void)addRequest:(WXZRequest *)request;

- (void)cancelRequest:(WXZRequest *)request;

- (void)cancelAllRequests;

/// 根据request和networkConfig构建url
- (NSString *)buildRequestUrl:(WXZRequest *)request;

@end
