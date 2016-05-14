//
//  ViewController.m
//  WXZNetWorking
//
//  Created by 王向召 on 16/5/2.
//  Copyright © 2016年 王向召. All rights reserved.
//

#import "ViewController.h"
#import "MYBEncryToos.h"
#import "MYBNetWorkConfig.h"
#import "MYBParamsFilter.h"
#import "MYBRequest.h"
#import "MYBHttpModel.h"
#import "MYBLoginAccount.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MYBNetWorkConfig *config = [MYBNetWorkConfig sharedInstance];
    MYBParamsFilter *filter = [MYBParamsFilter filterWithParams:[self toHeadDict]];
    [config addParamFilter:filter];
    config.baseUrl = @"http://api.meiyebang.com:9000";
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"13269532539" forKey:@"mobile"];
    [dict setValue:@"123456" forKey:@"password"];
    [dict setValue:@0 forKey:@"isNotAuto"];
    MYBRequest *request = [[MYBRequest alloc] init];
    request.associatedClass = [MYBLoginAccount class];
    request.params = dict;
    request.requestUrl = @"/clerk/loginAccount/login";
    
    [request startWithCompletionBlockWithSuccess:^(__kindof MYBRequest *request) {
        MYBLoginAccount *account = request.responseObject;
        NSLog(@"%@",account.code);
    } failure:^(__kindof MYBRequest *request) {
        NSLog(@"%@",request.responseError);
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)toHeadDict {
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary *headContentDict = [NSMutableDictionary dictionary];
    [headContentDict setValue:@"IOS_B_PAD_COMPANY" forKey:@"appType"];
    [headContentDict setValue:nowVersion forKey:@"appVersion"];
    [headContentDict setValue:@"2.4.1" forKey:@"apiVersion"];
    [headContentDict setValue:@"" forKey:@"deviceToken"];
    [headContentDict setValue:@""  forKey:@"token"];
    [headContentDict setValue:[MYBEncryToos encryMessage:[NSString stringWithFormat:@"%@",[NSDate date]]] forKey:@"digest"];//md5
    [headContentDict setValue:[MYBEncryToos encryMessage:[NSString stringWithFormat:@"%@",[NSDate date]]] forKey:@"timestamp"];
    [headContentDict setValue:@"" forKey:@"operator"];
    [headContentDict setValue:@"CLERK_LOGIN" forKey:@"operatorType"];
    [headContentDict setValue:@"QIANTAI" forKey:@"operatorLevel"];
    return headContentDict;
    return nil;
}

@end
