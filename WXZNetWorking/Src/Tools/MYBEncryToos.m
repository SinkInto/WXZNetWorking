//
//  MYBEncryToos.m
//  Encryption
//
//  Created by wangxiangzhao on 15/11/12.
//  Copyright © 2015年 wangxiangzhao. All rights reserved.
//

#import "MYBEncryToos.h"
#import "MYBFileTool.h"
#import <CommonCrypto/CommonCryptor.h>

#define KEY_ENCRYPTION @"9ce62c1836d128czc8a5c9126ddb564z"

static NSString *const encry_file_password = @"~@__$$MYBFileEncryPassword$$__@~";
static NSString *const encry_message_password = @"~@__$$MYBFileEncryPassword$$__@~";

@implementation MYBEncryToos

+ (NSString *)encryMessage:(NSString *)message {
    return [MYBEncryToos encryMessage:message password:KEY_ENCRYPTION];
}

+ (NSString *)encryMessage:(NSString *)message password:(NSString *)password {
    NSData *encry = [message dataUsingEncoding:NSUTF8StringEncoding];
    encry = [encry AES256EncryptWithKey:password];
    return [MYBEncryToos byteToString:encry];
}

+ (NSString *)decryMessage:(NSString *)message {
    return [MYBEncryToos decryMessage:message password:KEY_ENCRYPTION];
}

+ (NSString *)decryMessage:(NSString *)message password:(NSString *)password {
    NSData *decrypt = [MYBEncryToos stringToByte:message];
    decrypt = [decrypt AES256DecryptWithKey:password];
    return [[NSString alloc] initWithData:decrypt encoding:NSUTF8StringEncoding];
}

+ (void)encryFileWithFileName:(NSString *)fileName ofType:(NSString *)type {
    NSString *path = [MYBFileTool getResourcesFile:fileName ofType:type];
    NSString *file = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *encry = [MYBEncryToos encryMessage:file password:encry_file_password];
    if(encry) {
        [encry writeToFile:[MYBFileTool getLocalFilePath:fileName]
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:NULL];
    }
    
}

+ (NSString *)decryFileWithEncryedFileName:(NSString *)fileName {
    return [MYBEncryToos decryFileWithEncryedFileName:fileName password:encry_file_password];
}

+ (id)decryFileWithEncryedFileName:(NSString *)fileName password:(NSString *)password {
    NSString *path = [MYBFileTool getResourcesFile:fileName ofType:nil];
    NSString *file = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *deEncry = [MYBEncryToos decryMessage:file password:password];
    NSData *data = [deEncry dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

+ (NSData*)stringToByte:(NSString*)string {
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

+ (NSString*)byteToString:(NSData*)data {
    Byte *plainTextByte = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",plainTextByte[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

@end

@implementation NSData (Encryption)


- (NSData *)AES256EncryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          "0000000000000000" /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          "0000000000000000" /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

@end
