//
//  MYBAlertUtil.h
//  Meiyebang
//
//  Created by yechunyuan on 14/10/31.
//  Copyright (c) 2014年 yechunyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^AlertUtilCompleteBlock)(NSInteger buttonIndex);

@interface MYBAlertUtil : NSObject

+ (void)show:(NSString *)message;

+ (void)show:(NSString *)message completeBlock:(AlertUtilCompleteBlock)completeBlock;

+ (void)show:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)cancelButtonTitle completeBlock:(AlertUtilCompleteBlock) completeBlock;

+ (void)showToast:(UIView *)view message:(NSString *)message;

+ (void)showToast:(UIView *)view message:(NSString *)message completeBlock:(AlertUtilCompleteBlock)block;

@end
