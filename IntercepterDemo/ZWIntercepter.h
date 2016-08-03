//
//  ZWIntercepter.h
//  Pods
//
//  Created by zhuwei on 15/8/6.
//
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"
#import "ZWSingleton.h"

#define kZWIntercepterPropertyKey           @"kZWIntercepterPropertyKey"
#define kZWInterceptedInstancePropertyKey   @"kZWInterceptedInstancePropertyKey"

#undef INTERCEPT_CLASS
#define INTERCEPT_CLASS( __class )  \
+ (Class)interceptedClass \
{ \
    return [__class class];\
} \
- (void)setInterceptedInstance:(__class *)instance \
{ \
    objc_setAssociatedObject(self, kZWInterceptedInstancePropertyKey, instance, OBJC_ASSOCIATION_ASSIGN);\
} \
- (__class *)interceptedInstance \
{ \
    id interceptedInstance = objc_getAssociatedObject(self, kZWInterceptedInstancePropertyKey); \
    return (__class *)interceptedInstance;\
}


/**
 *  拦截者协议
 */
@protocol ZWIntercepterProtocol <NSObject>


@end



/**
 *  AOP拦截器
 */
@interface ZWIntercepter : NSObject 
    

INTERFACE_SINGLETON(ZWIntercepter)

/**
 *  初始化AOP
 */
+ (void)setup;

@end
