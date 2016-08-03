//
//  ViewController.m
//  IntercepterDemo
//
//  Created by teacher on 16/8/3.
//  Copyright © 2016年 teacher. All rights reserved.
//

#import "ViewController.h"
#import "MyDemo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loginWithUsername:@"test" password:@"pwd"];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)pwd {
    NSLog(@"进行登录逻辑");
}

@end
