//
//  MYBParamsFilter.h
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/27.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXZNetWorkConfig.h"


@interface WXZParamsFilter : NSObject <MYBParamsFilterProtocol>

+ (WXZParamsFilter *)filterWithParams:(NSDictionary *)params;

- (NSDictionary *)filterOriginParams:(NSDictionary *)originParams;

@end
