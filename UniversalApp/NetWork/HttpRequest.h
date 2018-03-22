//
//  HttpRequest.h
//  NetWorking
//  网络请求封装
//  Created by 王玉 on 16/4/19.
//  Copyright © 2016年 王玉. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;

typedef enum : NSInteger{
    OrbYunHttp,//进行AFHttpRequestSerializer
    OrbYunJSON,
    OrbYunHttpJSON,
    OrbYunJSONHttp,
}OrbYuntSerializerType;

@class ORBNet;

@interface HttpRequest : NSObject
{
    @public
    AFHTTPSessionManager *_manager;
}

//获取网络请求对象
+ (instancetype)getInstance;

/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 
 */
- (NSURLSessionTask *)getWithURLString:(NSString *)URLString
                               headers:(NSDictionary *)headers
                            orbYunType:(OrbYuntSerializerType)type
                            parameters:(id)parameters
                               success:(void (^)(id responseObject,NSURLSessionTask * task)) success
                               failure:(void (^)(NSError * error,NSURLSessionTask * task))failure;

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 */
- (NSURLSessionTask *)postWithURLString:(NSString *)URLString
                                headers:(NSDictionary *)headers
                             orbYunType:(OrbYuntSerializerType)type
                             parameters:(id)parameters
                                success:(void (^)(id responseObject,NSURLSessionTask * task))success
                                failure:(void (^)(NSError * error,NSURLSessionTask * task))failure;


/**
 *  上传文件
 *
 *  @param URLString   上传文件的网址字符串
 *  @param headers     设置请求头
 *  @param type        设置请求类型Http or JSON
 *  @param parameters  上传文件的参数
 *  @param uploadParam 上传文件的信息
 *  @param success     上传成功的回调
 *  @param failure     上传失败的回调
 *
 *  @return 返回请求任务对象
 */
- (NSURLSessionTask *)uploadWithURLString:(NSString *)URLString
                                  headers:(NSDictionary *)headers
                               orbYunType:(OrbYuntSerializerType)type
                               parameters:(id)parameters
                            blockprogress:(void (^)(NSProgress *uploadProgress))prograss
                              filePathUrl:(NSString *)pathUrl
                                  success:(void (^)(id responseObject,NSURLSessionTask * task))success
                                  failure:(void (^)(NSError * error,NSURLSessionTask * task))failure;
/**
 *  下载文件
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 */
- (NSURLSessionTask *)downLoadWithURLString:(NSString *)URLString
                                    headers:(NSDictionary *)headers
                                 orbYunType:(OrbYuntSerializerType)type
                                 parameters:(id)parameters
                              blockprogress:(void (^)(NSProgress *))prograss
                                    success:(void (^)(id responseObject,NSURLSessionTask * task))success
                                    failure:(void (^)(NSError * error,NSURLSessionTask * task))failure;

/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 
 */
- (NSURLSessionTask *)getNewWithURLString:(NSString *)URLString
                                  headers:(NSDictionary *)headers
                               orbYunType:(OrbYuntSerializerType)type
                               parameters:(id)parameters
                                  success:(void (^)(id, NSURLSessionTask *))success
                                  failure:(void (^)(NSError *, NSURLSessionTask *))failure;

/**
 *  发送post请求 含上传进度的
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 */

- (NSURLSessionTask *)postProgressWithURLString:(NSString *)URLString headers:(NSDictionary *)headers orbYunType:(OrbYuntSerializerType)type parameters:(id)parameters progress:(void (^)(float pro))progress success:(void (^)(id responseObject, NSURLSessionTask *task))success failure:(void (^)(NSError *error, NSURLSessionTask *task))failure;


/**
 *  发送GzipPost请求
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 */
- (NSURLSessionTask *)postGzipWithURLString:(NSString *)URLString
                                headers:(NSDictionary *)headers
                             orbYunType:(OrbYuntSerializerType)type
                             parameters:(id)parameters
                                success:(void (^)(id responseObject,NSURLSessionTask * task))success
                                failure:(void (^)(NSError * error,NSURLSessionTask * task))failure;

/**
 *  取消网络请求
 */
+ (void)cancel;

@end
