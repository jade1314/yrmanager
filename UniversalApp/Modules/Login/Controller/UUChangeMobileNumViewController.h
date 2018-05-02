//
//  UUChangeMobileNumViewController.h
//  UniversalApp
//
//  Created by 王玉 on 2018/5/2.
//  Copyright © 2018年 UU. All rights reserved.
//

#import "RootViewController.h"

typedef enum : NSUInteger {
    PageTypeMobile,
    PageTypePassword,
} PageType;

@interface UUChangeMobileNumViewController : RootViewController
@property (nonatomic, assign) PageType type;
@end
