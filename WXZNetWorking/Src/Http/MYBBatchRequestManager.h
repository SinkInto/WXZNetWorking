//
//  MYBBatchRequestManager.h
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/27.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYBBatchRequest.h"

@interface MYBBatchRequestManager : NSObject

+ (MYBBatchRequestManager *)sharedInstance;

- (void)addBatchRequest:(MYBBatchRequest *)request;

- (void)removeBatchRequest:(MYBBatchRequest *)request;

- (void)removeAllBatchRequests;

@end
