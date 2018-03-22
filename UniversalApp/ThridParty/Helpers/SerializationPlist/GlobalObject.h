//
//  GlobalObject.h
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

/*对象序列化成文件时保存的路径*/
#define vGlobalObjectSavePath  ([ToolHelper getConfigFile:[NSString stringWithFormat:@"%@/GlobalObjectData.plist",[defaults objectForKey:USER_ID]]])
#define vGlobalRemarkNamesSavePath  ([ToolHelper getConfigFile:[NSString stringWithFormat:@"%@/GlobalRemarkNames.plist",[defaults objectForKey:USER_ID]]])
#define vGlobalAdvertisementSavePath  ([ToolHelper getConfigFile:[NSString stringWithFormat:@"%@/GlobalAdvertisementData.plist",[defaults objectForKey:USER_ID]]])

@interface GlobalObject : NSObject

@property (nonatomic, assign) BOOL  refresh;  //当用户退出时,需要重新加载
@property (nonatomic, retain) NSMutableDictionary *globalDic;
@property (nonatomic, retain) NSMutableDictionary *remarkNamesDic;
@property (nonatomic, retain) NSMutableArray *advertisementArray;
+ (GlobalObject *) shareGlobalObject;
+(void)saveRemarkName;
+(void)saveGlobalObject;
+(void)saveAdvertisement;
+ (void)closeGlobalObject;
- (void)loadRemarkNamesDic;
- (void)loadGlobalDic;
- (void)loadAdvertisementArray;

@end
