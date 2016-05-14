//
//  MYBHttpModel.m
//  WXZNetWorking
//
//  Created by 王向召 on 16/5/14.
//  Copyright © 2016年 王向召. All rights reserved.
//

#import "MYBHttpModel.h"
#import "MYBNetWorkPrivite.h"

@implementation MYBHttpModel


#pragma mark - util 

+ (id)getFromJson:(NSDictionary *)dict {
    return [[self alloc] mj_setKeyValues:dict];
}

+ (NSArray *)getArrayFromJson:(NSArray *)array {
    if (![array isKindOfClass:[NSArray class]]) return [NSArray new];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mutableArray addObject:[[self class] getFromJson:obj]];
    }];
    return mutableArray;
}

+ (id)jsonToModel:(id)json {
    if ([json isKindOfClass:[NSArray class]]) return [[self class] getArrayFromJson:json];
    else if ([json isKindOfClass:[NSDictionary class]]) return [[self class] getFromJson:json];
    else return json;
}

#pragma mark - HttpResponseObjectProtocol

+ (id)httpResponseObject:(id)responseObject {
    return [MYBNetWorkPrivite handelResponseObject:responseObject associatedClass:self];
}

@end
