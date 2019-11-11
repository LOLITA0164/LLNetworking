//
//  LLViewController.m
//  LLNetworking
//
//  Created by LOLITA0164 on 11/08/2019.
//  Copyright (c) 2019 LOLITA0164. All rights reserved.
//

#import "LLViewController.h"
#import <LLNetworking/LLNetworking.h>

@interface LLViewController ()

@end

@implementation LLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    LLNetworking * networking = LLNetworking.new;
    [networking POSTWithURLString:@"www.baidu.com" parameters:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(id error) {
        NSLog(@"%@",error);
    }];
    [networking doSomething];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
