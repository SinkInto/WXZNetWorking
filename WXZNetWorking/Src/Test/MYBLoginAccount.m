//
//  MYBLoginAccount.m
//  WXZNetWorking
//
//  Created by 王向召 on 16/5/14.
//  Copyright © 2016年 王向召. All rights reserved.
//

#import "MYBLoginAccount.h"

@implementation MYBLoginAccount

+ (id)getFromJson:(NSDictionary *)dict {
    
    return [[self alloc] mj_setKeyValues:dict];
}

@end
