//
//  GlobalObject.m
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "GlobalObject.h"

static GlobalObject *globalObject = nil;

@implementation GlobalObject

@synthesize refresh;
@synthesize globalDic;
@synthesize remarkNamesDic;
@synthesize advertisementArray;
- (id)init {
    if (self = [super init]) {
        self.refresh = NO;
        [self loadGlobalDic];
        [self loadRemarkNamesDic];
        [self loadAdvertisementArray];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone{
    return self;
}
//- (id) retain{
//    return self;
//}
//
//- (id) autorelease{
//    return self;
//}
//- (void)dealloc{
//    
//    [globalObject release];
//    [super dealloc];
//}

+ (GlobalObject *) shareGlobalObject{
    @synchronized(self){
        if (globalObject == nil){
            globalObject = [[self alloc] init];
        }
        if (globalObject.refresh) {
            [globalObject loadGlobalDic];
            [globalObject loadRemarkNamesDic];
            [globalObject loadAdvertisementArray];
            globalObject.refresh = NO;
        }
    }
    return globalObject;
}
+ (void)closeGlobalObject{
    [globalObject.globalDic  writeToFile:vGlobalObjectSavePath atomically:NO];
    [globalObject.remarkNamesDic writeToFile:vGlobalRemarkNamesSavePath atomically:NO];
    [globalObject.advertisementArray writeToFile:vGlobalAdvertisementSavePath atomically:NO];
    globalObject.refresh = YES;
    //  [globalObject.remarkNamesDic removeAllObjects];
    [globalObject.globalDic removeAllObjects];
    [globalObject.advertisementArray removeAllObjects];
}
+(void)saveRemarkName{
    [globalObject.remarkNamesDic writeToFile:vGlobalRemarkNamesSavePath atomically:NO];
    NSLog(@"%@", vGlobalRemarkNamesSavePath );
}
+(void)saveGlobalObject{
    [globalObject.globalDic  writeToFile:vGlobalObjectSavePath atomically:NO];
}
+(void)saveAdvertisement
{
    [globalObject.advertisementArray  writeToFile:vGlobalAdvertisementSavePath atomically:NO];
}
- (void)loadRemarkNamesDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:vGlobalRemarkNamesSavePath];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    self.remarkNamesDic = dic;
}
- (void)loadGlobalDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:vGlobalObjectSavePath];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    self.globalDic = dic;
}
- (void)loadAdvertisementArray{
    NSMutableArray *advertisementDataArray = [NSMutableArray arrayWithContentsOfFile:vGlobalAdvertisementSavePath];
    if (!advertisementDataArray) {
        advertisementDataArray = [NSMutableArray array];
    }
    self.advertisementArray = advertisementDataArray;
}

@end
