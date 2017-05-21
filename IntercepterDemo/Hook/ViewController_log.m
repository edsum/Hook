//
//  ViewController_log.m
//  IntercepterDemo
//
//  Created by Iean on 16/8/3.
//  Copyright © 2016年 Iean. All rights reserved.
//

#import "ViewController_log.h"
#import "ViewController.h"

@implementation ViewController_log

INTERCEPT_CLASS(ViewController)

- (void)before_loginWithUsername:(NSString *)username password:(NSString *)pwd {
    NSLog(@"登录开始");
}

- (void)after_loginWithUsername:(NSString *)username password:(NSString *)pwd {
    NSLog(@"登录结束");
}
@end
