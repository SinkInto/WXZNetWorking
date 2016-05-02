//
//  MYBBatchRequestManager.h
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/27.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXZBatchRequest.h"

@interface WXZBatchRequestManager : NSObject

+ (WXZBatchRequestManager *)sharedInstance;

- (void)addBatchRequest:(WXZBatchRequest *)request;

- (void)removeBatchRequest:(WXZBatchRequest *)request;

- (void)removeAllBatchRequests;

@end
