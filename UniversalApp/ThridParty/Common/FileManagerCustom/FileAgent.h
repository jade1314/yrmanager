//
//  FileAgent.h
//  xiangyunDemo
//  业务模块直接调用,用于对系统业务相关的文件进行管理,包括文件的删除、创建、添加内容、拷贝等操作
//  Created by jade on 16/5/6.
//  Copyright © 2016年 jade. All rights reserved.
//

//#import <Foundation/Foundation.h>

@interface FileAgent : NSObject

/**
 * 获取Document路径
 */
-(BOOL) getDocumentDirectory;
/**
 * 获取全路径(记前面加上docment路径的绝对路径)
 */
-(NSString *) getFullDirectory:(NSString *)shortPath;
/**
 * 清空指定文件夹
 * targetPath:文件夹全路径
 * folderName:文件夹名称
 */
-(BOOL) clearFolder:(NSString *)targetPath targetFolderName:(NSString *)folderName;
/**
 * 实现单例方法,线程安全的
 * 调用方式
 */
+(FileAgent *)getInstance;

@end
