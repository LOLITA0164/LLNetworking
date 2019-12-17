//
//  LLNetworking.m
//  LLNetworking_Example
//
//  Created by 骆亮 on 2019/11/8.
//  Copyright © 2019 LOLITA0164. All rights reserved.
//

#import "LLNetworking.h"

typedef NS_ENUM(NSUInteger,HttpRequestType){
    Get = 0,
    Post
};

@implementation LLNetworking

#pragma mark - 数据请求
-(void)POST:(NSString*)urlString parameters:(id)parameters success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSError* error))failure{
    [self requestWithURLString:urlString parameters:parameters type:Post success:success failure:failure];
}
-(void)GET:(NSString*)urlString parameters:(id)parameters success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSError* error))failure{
    [self requestWithURLString:urlString parameters:parameters type:Get success:success failure:failure];
}
-(void)requestWithURLString:(NSString *)URLString parameters:(id)parameters type:(HttpRequestType)type success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    if(![self requestBeforeCheckNetWork]){
        NSError *error = [NSError errorWithDomain:NSURLErrorKey code:-1000 userInfo:@{@"error":@"没有网络"}];
        failure(error);
        return;
    }
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    manager.operationQueue.maxConcurrentOperationCount = 10;
    // 拼接地址
    if (parameters) {
        NSString *urlStringTmp = URLString;
        if (![urlStringTmp containsString:@"?"]) {
            urlStringTmp = [urlStringTmp stringByAppendingString:@"?"];
        }
        for (NSString *key in parameters) {
            NSString*value = parameters[key];
            NSString* item = [NSString stringWithFormat:@"&%@=%@",key,value];
            urlStringTmp = [urlStringTmp stringByAppendingString:item];
        }
        NSLog(@"LLLLLLLL数据地址：%@",urlStringTmp);
    }else{
        NSLog(@"LLLLLLLL数据地址：%@",URLString);
    }
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    switch (type) {
        case Get:{
            self.myTask = [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
                if (success) {
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    success(dic);
                }
                // 释放掉 session 会话
                [manager.session invalidateAndCancel];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if (failure) {
                    failure(error);
                }
                // 释放掉 session 会话
                [manager.session invalidateAndCancel];
            }];
        }
            break;
        default:{
            self.myTask = [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
                if (success) {
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    success(dic);
                }
                // 释放掉 session 会话
                [manager.session invalidateAndCancel];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if (failure) {
                    failure(error);
                }
                // 释放掉 session 会话
                [manager.session invalidateAndCancel];
            }];
        }
            break;
    }
}


#pragma mark - 上传图片或者视频
-(void)upload:(NSString *)URLString parameters:(id)parameters images:(NSArray*)imgsArray videos:(NSArray*)videosArray uploadProgress:(void(^)(NSProgress * uploadPro))uploadPro success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSError* error))failure{
    if(![self requestBeforeCheckNetWork]){
        NSError *error = [NSError errorWithDomain:NSURLErrorKey code:-1000 userInfo:@{@"error":@"没有网络"}];
        failure(error);
        return;
    }
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 拼接地址
    if (parameters) {
        NSString *urlStringTmp = URLString;
        for (NSString *key in parameters) {
            NSString*value = parameters[key];
            NSString* item = [NSString stringWithFormat:@"&%@=%@",key,value];
            urlStringTmp = [urlStringTmp stringByAppendingString:item];
        }
        NSLog(@"LLLLLLLL数据地址：%@",urlStringTmp);
    }else{
        NSLog(@"LLLLLLLL数据地址：%@",URLString);
    }
    self.myTask = [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //图片
        if (imgsArray.count) {
            for (int i=0; i<imgsArray.count; i++) {
                UIImage *image = imgsArray[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg",dateString];
                //media为服务器文件夹
                [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpeg"];
            }
        }
        //视频
        if (videosArray.count) {
            for (int i = 0; i < videosArray.count; i++) {
                NSData *data=[videosArray objectAtIndex:i];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString  stringWithFormat:@"%@.MOV", dateString];
                [formData appendPartWithFileData:data name:@"files" fileName:fileName mimeType:@"media"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgress) {
            uploadPro(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        // 释放掉 session 会话
        [manager.session invalidateAndCancel];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        // 释放掉 session 会话
        [manager.session invalidateAndCancel];
    }];
}


#pragma mark - 取消网络任务
-(void)cancelRequest{
    [self.myTask cancel];
}


#pragma mark  请求前统一处理：如果是没有网络，则不论是GET请求还是POST请求，均无需继续处理
- (BOOL)requestBeforeCheckNetWork {
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable  =(isReachable && !needsConnection) ? YES : NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible =isNetworkEnable;/*  网络指示器的状态： 有网络 ： 开  没有网络： 关  */
    });
    return isNetworkEnable;
}

@end
