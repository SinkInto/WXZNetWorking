//
//  MYBHttpModel.h
//  WXZNetWorking
//
//  Created by 王向召 on 16/5/14.
//  Copyright © 2016年 王向召. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "MYBRequest.h"

@interface MYBHttpModel : NSObject <HttpResponseObjectProtocol>


+ (id)jsonToModel:(id)json;

@end
