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
@property(strong,nonatomic)NSURLSessionDataTask *task;
- (NSURLSessionDataTask *)POSTWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(id error))failure;
-(void)doSomething;
@end

