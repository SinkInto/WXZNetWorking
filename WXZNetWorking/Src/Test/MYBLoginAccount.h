//
//  MYBLoginAccount.h
//  WXZNetWorking
//
//  Created by 王向召 on 16/5/14.
//  Copyright © 2016年 王向召. All rights reserved.
//

#import "MYBModel.h"

@interface MYBLoginAccount : MYBModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *clerkCode;
@property (nonatomic, copy) NSString *clerkName;
@property (nonatomic, assign) NSInteger clerkType;
@property (nonatomic, copy) NSString *shopCode;
@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSString *mobile;

@end
