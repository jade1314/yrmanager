//
//  NSData+Encryption.h
//  PanGu
//
//  Created by jade on 2016/11/1.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface NSData (Encryption)
//加密
-(NSData *) aes256_encrypt:(NSString *)key;
//解密
-(NSData *) aes256_decrypt:(NSString *)key;


@end
