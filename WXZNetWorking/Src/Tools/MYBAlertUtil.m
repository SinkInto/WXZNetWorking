//
//  MYBAlertUtil.m
//  Meiyebang
//
//  Created by yechunyuan on 14/10/31.
//  Copyright (c) 2014年 yechunyuan. All rights reserved.
//

#import "MYBAlertUtil.h"
#import "UIAlertView+Block.h"
#import "MBProgressHUD.h"

@implementation MYBAlertUtil

+ (void)show:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)show:(NSString *)message completeBlock:(AlertUtilCompleteBlock)completeBlock {
    [MYBAlertUtil show:message cancelButtonTitle:nil otherButtonTitle:@"确定" completeBlock:completeBlock];
}

+ (void)show:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle completeBlock:(AlertUtilCompleteBlock)completeBlock {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        completeBlock(buttonIndex);
    }];
}

+ (void)showToast:(UIView *)view message:(NSString *)message {
    [MYBAlertUtil showToast:view message:message completeBlock:nil];
}

+ (void)showToast:(UIView *)view message:(NSString *)message completeBlock:(AlertUtilCompleteBlock)block {
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:progressHUD];
    progressHUD.labelText = message;
    progressHUD.mode = MBProgressHUDModeText;
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    progressHUD.yOffset = -150.0f;
    //    progressHUD.xOffset = 100.0f;
    [progressHUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [progressHUD removeFromSuperview];
        if (block) {
            block(0);
        }
    }];
}

@end
