//
//  NSString+URLEncode.h
//  PanGu
//
//  Created by jade on 2016/11/2.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)

+(NSString*)encodeString:(NSString*)unencodedString;

-(NSString *)decodeString:(NSString*)encodedString;

@end
