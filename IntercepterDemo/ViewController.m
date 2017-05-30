//
//  ViewController.m
//  IntercepterDemo
//
//  Created by Iean on 16/8/3.
//  Copyright © 2016年 Iean. All rights reserved.
//

#import "ViewController.h"

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
