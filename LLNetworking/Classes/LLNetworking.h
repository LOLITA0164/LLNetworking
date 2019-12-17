//
//  LLNetworking.h
//  LLNetworking_Example
//
//  Created by 骆亮 on 2019/11/8.
//  Copyright © 2019 LOLITA0164. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


@interface LLNetworking : NSObject
@property(strong ,nonatomic) NSURLSessionDataTask *myTask;

#pragma mark - 数据请求
-(void)POST:(NSString*)urlString parameters:(id)parameters success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSError* error))failure;
-(void)GET:(NSString*)urlString parameters:(id)parameters success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSError* error))failure;

#pragma mark - 上传图片或者视频
-(void)upload:(NSString *)URLString parameters:(id)parameters images:(NSArray*)imgsArray videos:(NSArray*)videosArray uploadProgress:(void(^)(NSProgress * uploadPro))uploadPro success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSError* error))failure;

#pragma mark - 取消网络任务
-(void)cancelRequest;

@end

