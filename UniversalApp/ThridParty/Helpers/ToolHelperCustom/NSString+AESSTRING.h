//
//  NSString+AESSTRING.h
//  PanGu
//
//  Created by jade on 2016/11/2.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSString (AESSTRING)
//256加密
-(NSString *) aes256_encrypt:(NSString *)key;
//256解密
-(NSString *) aes256_decrypt:(NSString *)key;
//128加密
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;
//128解密
+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;

// 普通字符串转换为十六进
+ (NSString *)hexStringFromData:(NSData *)data;

//十六进制转Data
+ (NSData*)dataForHexString:(NSString*)hexString;

@end
