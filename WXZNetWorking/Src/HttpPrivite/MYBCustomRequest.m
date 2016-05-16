//
//  MYBCustomRequest.m
//  WXZNetWorking
//
//  Created by 王向召 on 16/5/16.
//  Copyright © 2016年 王向召. All rights reserved.
//

#import "MYBCustomRequest.h"
#import "MBProgressHUD.h"
#import "MYBAlertUtil.h"
#import "MYBHttpModel.h"

@implementation MYBCustomRequest

- (void)customCompletionWithSuccess:(MYBCustomRequestCompletionBlock)success
                            failure:(MYBCustomRequestCompletionBlock)failure {
    [self customCompletionWithSuccess:success successMsg:nil failure:failure inView:nil];
}

- (void)customCompletionWithSuccess:(MYBCustomRequestCompletionBlock)success
                         successMsg:(NSString *)successMsg
                            failure:(MYBCustomRequestCompletionBlock)failure {
    [self customCompletionWithSuccess:success successMsg:successMsg failure:failure inView:nil];
}

- (void)customCompletionWithSuccess:(MYBCustomRequestCompletionBlock)success
                         successMsg:(NSString *)successMsg
                            failure:(MYBCustomRequestCompletionBlock)failure
                             inView:(UIView *)view {
    [self showHUDInView:view];
    __weak typeof(self) weakSelf = self;
    [self startWithCompletionBlockWithSuccess:^(__kindof MYBRequest *request) {
        [weakSelf completionWithRequest:request successMsg:successMsg done:^(id data, MYBError *error, NSDictionary *dict) {
            [weakSelf hideHUDInView:view];
            if (error) {
                if (failure) failure(nil,error,dict);
                return;
            }
            if (success) success(data,error,dict);
        }];
    } failure:^(__kindof MYBRequest *request) {
        [weakSelf completionWithRequest:request successMsg:successMsg done:^(id data, MYBError *error, NSDictionary *dict) {
            [weakSelf hideHUDInView:view];
            if (failure) failure(nil,error,dict);
        }];
    }];
}

- (void)completionWithRequest:(MYBRequest *)request successMsg:(NSString *)msg done:(MYBCustomRequestCompletionBlock)done {
    NSLog(@"%ld----%@",request.responseCode,request.responseObject);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (request.responseCode == 0) {
        [MYBAlertUtil showToast:window message:@"请检查网络"];
        if (done) {
            MYBError *error = [MYBError errorWithMsg:@"请检查网络" code:0 userInfo:nil];
            done(nil,error,[NSDictionary dictionary]);
        }
        return;
    }
    if (request.responseObject) {
        NSDictionary *headDict = request.responseObject[@"head"];
        NSDictionary *body = request.responseObject[@"body"];
        NSInteger errorCode = [headDict[@"errCode"] integerValue];
        if (errorCode == 1000) {
            if (msg.length > 0) [MYBAlertUtil showToast:window message:msg];
            if ([self.associatedModel respondsToSelector:@selector(jsonToModel:)]) {
              done([self.associatedModel jsonToModel:body],nil,[NSDictionary dictionary]);
            } else {
              done([self.associatedModel jsonToModel:body],nil,[NSDictionary dictionary]);
            }
        } else if (errorCode == 1001) {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"TOKEN_EXPIRED" object:nil];
        } else {
            NSString *noticeMsg = body[@"errMsg"];
            if (noticeMsg.length <= 0) {
                if (errorCode == 1002) {
                    noticeMsg = @"验证码输入错误";
                } else if (errorCode == 1003) {
                    noticeMsg = @"数据存取异常";
                } else if (errorCode == 1004) {
                    noticeMsg = @"信息已提交,不能短时间内重复提交";
                } else if (errorCode == 1005) {
                    noticeMsg = @"输入参数错误";
                } else if (errorCode == 1006) {
                    noticeMsg = @"信息存储错误";
                } else {
                    noticeMsg = @"未知异常";
                }
            }
            [MYBAlertUtil showToast:window message:noticeMsg];
            if (done) done(nil,[MYBError errorWithMsg:noticeMsg code:errorCode userInfo:nil],headDict);
        }
        
        return;
    }
    
    MYBError *error = [MYBError errorWithMsg:@"未知异常" code:INT16_MAX userInfo:nil];
    done(nil,error,[NSDictionary dictionary]);
}

- (void)showHUDInView:(UIView *)view {
    if (!view) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    });
}

- (void)hideHUDInView:(UIView *)view {
    if (!view) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
    });
}

@end
