//
//  MYBEncryToos.h
//  Encryption
//
//  Created by wangxiangzhao on 15/11/12.
//  Copyright © 2015年 wangxiangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYBEncryToos : NSObject

+ (NSString *)encryMessage:(NSString *)message;
+ (NSString *)encryMessage:(NSString *)message password:(NSString *)password;
+ (NSString *)decryMessage:(NSString *)message;
+ (NSString *)decryMessage:(NSString *)message password:(NSString *)password;

+ (void)encryFileWithFileName:(NSString *)fileName ofType:(NSString *)type;

+ (NSString *)decryFileWithEncryedFileName:(NSString *)fileName;

+ (id)decryFileWithEncryedFileName:(NSString *)fileName password:(NSString *)password;

@end

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密

- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

@end
