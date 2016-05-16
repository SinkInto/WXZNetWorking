//
//  MYBCustomRequest.h
//  WXZNetWorking
//
//  Created by 王向召 on 16/5/16.
//  Copyright © 2016年 王向召. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYBRequest.h"
#import "MYBError.h"

typedef void(^MYBCustomRequestCompletionBlock)(id data, MYBError *error, NSDictionary *customDict);

@interface MYBCustomRequest : MYBRequest

@property (nonatomic, strong) Class associatedModel;

- (void)customCompletionWithSuccess:(MYBCustomRequestCompletionBlock)success
                            failure:(MYBCustomRequestCompletionBlock)failure;

- (void)customCompletionWithSuccess:(MYBCustomRequestCompletionBlock)success
                         successMsg:(NSString *)successMsg
                            failure:(MYBCustomRequestCompletionBlock)failure;

- (void)customCompletionWithSuccess:(MYBCustomRequestCompletionBlock)success
                         successMsg:(NSString *)successMsg
                            failure:(MYBCustomRequestCompletionBlock)failure
                             inView:(UIView *)view;

@end
