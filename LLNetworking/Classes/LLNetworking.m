//
//  LLNetworking.m
//  LLNetworking_Example
//
//  Created by 骆亮 on 2019/11/8.
//  Copyright © 2019 LOLITA0164. All rights reserved.
//

#import "LLNetworking.h"

@implementation LLNetworking
- (NSURLSessionDataTask *)POSTWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(id error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
   _task =  [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       if (success) {
           success(@{@"status":@"success"});
       }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(@{@"status":@"failure"});
        }
    }];
    return _task;
}

-(void)doSomething{
    NSLog(@"aaaa");
}
@end
