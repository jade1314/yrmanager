//
//  RegisterLoginViewController.h
//  PanGu
//
//  Created by Fll on 16/8/16.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "RootViewController.h"

typedef void(^registerType)(NSString *type);  //WeChat phoneNumber

@interface RegisterLoginViewController : RootViewController

@property (nonatomic,   copy) registerType RegisterType;


@end
