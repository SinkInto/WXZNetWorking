//
//  MYBNetWorkConfig.h
//  MeiYeBangSimple
//
//  Created by 王向召 on 16/4/26.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MYBParamsFilterProtocol <NSObject>

@optional

- (NSDictionary *)filterOriginParams:(NSDictionary *)originParams;

@end

@interface MYBNetWorkConfig : NSObject

+ (MYBNetWorkConfig *)sharedInstance;

@property (strong, nonatomic) NSString *baseUrl;
@property (strong, nonatomic) NSString *cdnUrl;
@property (strong, nonatomic, readonly) NSArray *paramFilters;


- (void)addParamFilter:(id<MYBParamsFilterProtocol>)filter;
- (id<MYBParamsFilterProtocol>)filterAtIndex:(NSInteger)index;
- (void)replaceParamFiltersAtIndex:(NSInteger)index withParamFilters:(id<MYBParamsFilterProtocol>)filter;

@end
