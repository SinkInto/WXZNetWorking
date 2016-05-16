//
//  MYBError.h
//  WXZNetWorking
//
//  Created by 王向召 on 16/5/16.
//  Copyright © 2016年 王向召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYBError : NSObject

+ (MYBError *)errorWithMsg:(NSString *)msg code:(NSInteger)code userInfo:(NSDictionary *)dict;

@property (nonatomic, copy, readonly) NSString *msg;
@property (nonatomic, assign, readonly) NSInteger code;
@property (nonatomic, strong, readonly) NSDictionary *userInfo;

@end
