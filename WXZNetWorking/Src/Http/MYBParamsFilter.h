//
//  MYBParamsFilter.h
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/27.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYBNetWorkConfig.h"


@interface MYBParamsFilter : NSObject <MYBParamsFilterProtocol>

+ (MYBParamsFilter *)filterWithParams:(NSDictionary *)params;

- (void)setFilterValue:(id)filterValue forKey:(NSString *)key;

- (NSDictionary *)filterOriginParams:(NSDictionary *)originParams;

@end
