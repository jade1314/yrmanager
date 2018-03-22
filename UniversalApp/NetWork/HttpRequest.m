//
//  HttpRequest.m
//  NetWorking
//  网络请求代理
//  Created by 王玉 on 16/4/19.
//  Copyright © 2016年 王玉. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest ()

@property (nonatomic,strong) NSHTTPURLResponse * response;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong)UIWindow * window;
@property (nonatomic, strong)UILabel * noticeLabel;
@property (nonatomic, assign)NetworkStatus remoteHostStatus;

@end

@implementation HttpRequest

//创建单利
+ (instancetype)getInstance {
    static HttpRequest *managerRe;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managerRe = [self new];
        managerRe.manager = [AFHTTPSessionManager manager];
        managerRe.manager.securityPolicy.allowInvalidCertificates = YES;
        //判断requestSerializer,responseSerializer请求和反馈类型
        managerRe.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        managerRe.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [managerRe.manager.requestSerializer setValue:K_VERSION_SHORT forHTTPHeaderField:@"VersionNum"];
        [managerRe.manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"AppType"];
        managerRe.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain" ,@"application/octet-stream",@"multipart/form-data",@"application/x-www-form-urlencoded",@"text/json",@"text/xml",@"image/*"]];
        managerRe.manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        managerRe.manager.securityPolicy.allowInvalidCertificates = YES;
        managerRe.manager.securityPolicy.validatesDomainName = NO;
        managerRe.manager.requestSerializer.timeoutInterval = 30.f;
        managerRe.manager.operationQueue.maxConcurrentOperationCount = 5;
    });
   
    return managerRe;

}

/**********************************网络请求参数设置**************************************/

-(void)dealloc{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark -- GET请求 --
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
                               success:(void (^)(id, NSURLSessionTask *))success
                               failure:(void (^)(NSError *, NSURLSessionTask *))failure{
    
    NSURLSessionTask *sessionTask;
    @try{
        //设置请求头
        for (NSString * key in headers) {
            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        //发送Get请求
        sessionTask = [_manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功,返回数据
            if (success) {
                _response = (NSHTTPURLResponse *)task.response;
                !success ? : success(responseObject,task);
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //请求失败,返回错误信息
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                !failure ? : failure(error,task);
            }
        }];

    }@catch(NSException *exception){
        
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
        
    }
    @finally{
        return sessionTask;
    }
}

#pragma mark -- POST请求 --
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
                                success:(void (^)(id, NSURLSessionTask *))success
                                failure:(void (^)(NSError *, NSURLSessionTask *))failure {
    NSURLSessionTask *sessionTask;
    @try{
        //设置请求头
        for (NSString * key in headers) {
            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        //发送Post请求
        sessionTask = [_manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功,返回数据
            if (success) {
                success(responseObject,task);
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
        }];
    }@catch(NSException *exception){
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
    }
    @finally{
        return sessionTask;
    }
    
    
}

#pragma mark -- 上传文件 --
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
                            blockprogress:(void (^)(NSProgress *))prograss
                              filePathUrl:(NSString *)pathUrl
                                  success:(void (^)(id, NSURLSessionTask *))success
                                  failure:(void (^)(NSError *, NSURLSessionTask *))failure{
    NSURLSessionTask *sessionTask;
    @try{
        //设置请求头
        for (NSString * key in headers) {
            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        //进行上传文件请求
        [_manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //拼接请求数据
            NSURL * fileUrl = [NSURL fileURLWithPath:pathUrl];
            
            NSArray *arr = [pathUrl componentsSeparatedByString:@"/"];
            [formData appendPartWithFileURL:fileUrl name:[arr lastObject] error:nil];
        }progress:^(NSProgress * _Nonnull uploadProgress) {
            //下载进度
            if (prograss) {
                prograss(uploadProgress);
            }
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功,返回数据
            if (success) {
                _response = (NSHTTPURLResponse *)task.response;
                success(responseObject,task);
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //请求失败,返回错误信息
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
        }];
    }@catch(NSException *exception){
        
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
        
    }
    @finally{
        return sessionTask;
    }
}
#pragma mark -- 下载文件 --
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
-(NSURLSessionTask *)downLoadWithURLString:(NSString *)URLString
                                   headers:(NSDictionary *)headers
                                orbYunType:(OrbYuntSerializerType)type
                                parameters:(id)parameters
                             blockprogress:(void (^)(NSProgress *))prograss
                                   success:(void (^)(id, NSURLSessionTask *))success
                                   failure:(void (^)(NSError *, NSURLSessionTask *))failure{
    NSURLSessionTask *sessionTask;
    @try{
        //设置请求头
        for (NSString * key in headers) {
            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        //进行下载Post请求
        sessionTask = [_manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            //下载进度
            if (prograss) {
                prograss(uploadProgress);
            }
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功,返回数据
            if (success) {
                _response = (NSHTTPURLResponse *)task.response;
                success(responseObject,task);
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //请求失败,返回错误信息
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
        }];
    }@catch(NSException *exception){
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
    }
    @finally{
        return sessionTask;
    }
}

#pragma mark -- GET请求 --
/**.
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
                               failure:(void (^)(NSError *, NSURLSessionTask *))failure{
    
    NSURLSessionTask *sessionTask;
    @try{
        //        设置请求头
        for (NSString * key in headers) {
            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        //发送Get请求
        sessionTask = [_manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功,返回数据
            if (success) {
                _response = (NSHTTPURLResponse *)task.response;
                success(responseObject,task);
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //请求失败,返回错误信息
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
        }];
    }@catch(NSException *exception){
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
        
    }
    @finally{
        return sessionTask;
    }
}

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

- (NSURLSessionTask *)postProgressWithURLString:(NSString *)URLString headers:(NSDictionary *)headers orbYunType:(OrbYuntSerializerType)type parameters:(id)parameters progress:(void (^)(float))progress success:(void (^)(id, NSURLSessionTask *))success failure:(void (^)(NSError *, NSURLSessionTask *))failure {
    
    NSURLSessionTask *sessionTask;
    @try{
        //设置请求头
        for (NSString * key in headers) {
            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        //发送Post请求
        sessionTask = [_manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            //返回上传进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功,返回数据
            if (success) success(responseObject,task);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
        }];
        
    }@catch(NSException *exception){
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
        
    }
    @finally{
        return sessionTask;
    }
}


/**
 *  发送Gzippost请求
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
                                success:(void (^)(id, NSURLSessionTask *))success
                                failure:(void (^)(NSError *, NSURLSessionTask *))failure {
    NSURLSessionTask *sessionTask;
    @try{
        
        //设置请求头
        for (NSString * key in headers) {
            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        //发送Post请求
        sessionTask = [_manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功,返回数据
            if (success) success(responseObject,task);
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
        }];

    }@catch(NSException *exception){
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
    }
    @finally{
        return sessionTask;
    }
}
//取消请求
+ (void)cancel {
    NSLog(@"manager.operationQueue.operationCount == %zd", [HttpRequest getInstance].manager.operationQueue.operationCount);
    NSArray *arr = [[HttpRequest getInstance].manager dataTasks];
    [arr enumerateObjectsUsingBlock:^(NSURLSessionDataTask * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
}

@end
