//
//  MYBError.m
//  WXZNetWorking
//
//  Created by 王向召 on 16/5/16.
//  Copyright © 2016年 王向召. All rights reserved.
//

#import "MYBError.h"

@implementation MYBError

+ (MYBError *)errorWithMsg:(NSString *)msg code:(NSInteger)code userInfo:(NSDictionary *)dict {
    return [[MYBError alloc] initWithMsg:msg code:code userInfo:dict];;
}

- (MYBError *)initWithMsg:(NSString *)msg code:(NSInteger)code userInfo:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _msg = msg;
        _code = code;
        _userInfo = dict;
    }
    return self;
}

@end
