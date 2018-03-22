//
//  FileAgent.m
//  xiangyunDemo
//  业务模块直接调用,用于对系统业务相关的文件进行管理,包括文件的删除、创建、添加内容、拷贝等操作
//  Created by jade on 16/5/6.
//  Copyright © 2016年 jade. All rights reserved.
//

#import "FileAgent.h"
#import "FileBMS.h"

@interface FileAgent ()
//Document路径
@property (nonatomic,retain) NSString *documentDirectory;
//文件管理工具类
@property (nonatomic,retain) FileBMS *fileManager;

@end


@implementation FileAgent

static FileAgent *instance=nil;
@synthesize documentDirectory;
@synthesize fileManager;

/**
 * 获取Document路径
 */
-(BOOL) getDocumentDirectory {
    BOOL bRet = NO;
    @try {
        fileManager = [FileBMS getInstance];
        documentDirectory =[fileManager getDocumentDirectory];//获取Docment路径
        bRet = YES;
    } @catch (NSException *exception) {
        [ToolHelper bmsLog:@"getDocumentDirectory: 获取Document路径失败"];
        NSLog(@"getDocumentDirectory: 获取Document路径失败 %@: %@", [exception name], [exception reason]);
    } @finally {
        return bRet;
    }
}

/**
 * 获取全路径(记前面加上docment路径的绝对路径)
 */
-(NSString *) getFullDirectory:(NSString *)shortPath {
    NSString *fullPath = nil;
    @try {
        if (nil == documentDirectory) {
            [self getDocumentDirectory];
        }
        fullPath =[documentDirectory stringByAppendingPathComponent:shortPath];
        
    } @catch (NSException *exception) {
        [ToolHelper bmsLog:@"getFullDirectory: 获取全路径(记前面加上docment路径的绝对路径)失败"];
        NSLog(@"getFullDirectory: 获取全路径(记前面加上docment路径的绝对路径)失败 %@: %@", [exception name], [exception reason]);
    } @finally {
        return fullPath;
    }
    
}
/**
 * 清空指定文件夹
 * targetPath:文件夹全路径
 * folderName:文件夹名称
 */
-(BOOL) clearFolder:(NSString *)targetPath targetFolderName:(NSString *)folderName{
    BOOL bRet = NO;
    NSArray *files=nil;//文件列表
    NSUInteger numberFiles = 0;//文件数量
    NSUInteger filesIndex=0;
    NSString *fileName=nil;
    @try {
        files = [fileManager getSubFiles:targetPath];
        if (nil == files) {
            bRet = YES;
            return bRet;
        }
        numberFiles = [files count];
        if (numberFiles <= 0) {
            bRet = YES;
            return bRet;
        }
        for (filesIndex = 0; filesIndex < numberFiles; filesIndex++){
            fileName = [folderName stringByAppendingPathComponent:files[filesIndex]];
            //参数形如：  logs/log20150119.log  相对路径
            bRet = [fileManager removeFile:fileName];
            if (bRet == NO) {
                [ToolHelper bmsLog:[NSString stringWithFormat:@"clearFolder: 清空指定文件夹时，删除文件:%@失败", fileName]];
                NSLog(@"删除文件:%@失败",fileName);
                return bRet;
            } else {
                [ToolHelper bmsLog:[NSString stringWithFormat:@"clearFolder: 　☆_☆清空指定文件夹时,成功删除文件:%@", fileName]];
                NSLog(@"成功删除文件:%@",fileName);
            }
            
            fileName=nil;
        }
        
    } @catch (NSException *exception) {
        [ToolHelper bmsLog:[NSString stringWithFormat:@"clearFolder: 清空指定文件夹:%@失败", targetPath]];
        NSLog(@"clearFolder: 清空指定文件夹失败 %@: %@", [exception name], [exception reason]);
    } @finally {
        return bRet;
    }
    
}

/**
 * 实现单例方法,线程安全的
 * 调用方式
 */
+(FileAgent *)getInstance {
    @synchronized(self) {
        if (nil == instance) {
            instance = [[self alloc] init];//该方法会调用 allocWithZone   [[super allocWithZone:NULL] init]
        }
    }
    return instance;
}

@end
