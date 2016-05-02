//
//  MYBNetWorkPrivite.h
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/26.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT void MYBLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

@interface WXZNetWorkPrivite : NSObject

+ (NSDictionary *)paramsWithOriginParams:(NSDictionary *)originParams appendParams:(NSDictionary *)params;

@end
