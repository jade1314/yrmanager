//
//  KalkulesTool.h
//  PanGu
//
//  Created by jade on 2017/9/12.
//  Copyright © 2017年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KalkulesTool)

@property (nonatomic, copy) NSString *(^add)(NSString *);
@property (nonatomic, copy) NSString *(^sub)(NSString *);
@property (nonatomic, copy) NSString *(^mul)(NSString *);
@property (nonatomic, copy) NSString *(^div)(NSString *);

@end
