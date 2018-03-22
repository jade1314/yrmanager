//
//  MakeFriendsLogic.h
//  UniversalApp
//
//  Created by JadeM on 2017/7/11.
//  Copyright © 2017年 JadeM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MakeFriendsDelegate <NSObject>
@optional
/**
 数据加载完成
 */
-(void)requestDataCompleted;

@end

@interface MakeFriendsLogic : NSObject
@property (nonatomic,strong) NSMutableArray * dataArray;//数据源
@property (nonatomic,assign) NSInteger  page;//页码

@property(nonatomic,weak)id<MakeFriendsDelegate> delegagte;

/**
 拉取数据
 */
-(void)loadData;

@end
