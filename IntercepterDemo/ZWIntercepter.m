//
//  ZWIntercepter.m
//  Pods
//
//  Created by zhuwei on 15/8/6.
//
//

#import "ZWIntercepter.h"
#import "objc/runtime.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
//#import <ZWCommonKit/NSObject+Perform.h>

#define GET_INTERCEPTER_METHOD_NAME     @"intercepter"
#define ORIG_METHOD_PREFIX              @"orig_"
#define INTERCEPTER_BEFORE_METHOD_NAME  @"before_"
#define INTERCEPTER_AFTER_METHOD_NAME   @"after_"


#undef AOP_CREATE_INVOCATION
#define AOP_CREATE_INVOCATION( __cmd ) \
NSMethodSignature *methodSignature = [target methodSignatureForSelector:__cmd];          \
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];\
va_list arguments;                                                                      \
va_start(arguments, __cmd);                                                              \
NSUInteger argumentCount = [methodSignature numberOfArguments];                         \
for (int index = 2; index < argumentCount; index++) {                                   \
    void *parameter = va_arg(arguments, void *);                                        \
    [invocation setArgument:&parameter atIndex:index];                                  \
}                                                                                       \
va_end(arguments);

//执行before方法
void execBeforeMethod(id target,SEL _cmd,NSInvocation *invocation) {
    NSString *methodName = NSStringFromSelector(_cmd);
    id intercepter = [target performSelector:@selector(intercepter)];
    if(intercepter != nil) {
        SEL beforeMethodSel = NSSelectorFromString([NSString stringWithFormat:@"%@%@",INTERCEPTER_BEFORE_METHOD_NAME,methodName]);
        if([intercepter respondsToSelector:beforeMethodSel]) {
            invocation.selector = beforeMethodSel;
            invocation.target = intercepter;
            [invocation invoke];
        }
    }
}

//执行after方法
void execAfterMethod(id target, SEL _cmd, NSInvocation *invocation) {
    NSString *methodName = NSStringFromSelector(_cmd);
    id intercepter = [target performSelector:@selector(intercepter)];
    //callback after
    if(intercepter != nil) {
        SEL afterMethodSel = NSSelectorFromString([NSString stringWithFormat:@"%@%@",INTERCEPTER_AFTER_METHOD_NAME,methodName]);
        if([intercepter respondsToSelector:afterMethodSel]) {
            invocation.selector = afterMethodSel;
            invocation.target = intercepter;
            [invocation invoke];
        }
    }
}

//执行原始方法
void execOrigMethod(id target, SEL _cmd, NSInvocation *invocation) {
    SEL origSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@",ORIG_METHOD_PREFIX,NSStringFromSelector(_cmd)]);
    invocation.selector = origSEL;
    invocation.target = target;
    [invocation invoke];
}
/**
 *  无返回值调用
 *
 *  @param target 调用目标
 *  @param _cmd   调用方法
 *  @param ...    参数
 */
void vCallbackDynamicMethodIMP(id target,SEL _cmd,...) {
    //处理参数
    AOP_CREATE_INVOCATION(_cmd);
    execBeforeMethod(target, _cmd, invocation);
    execOrigMethod(target,_cmd,invocation);
    execAfterMethod(target, _cmd, invocation);
}

/**
 *  OC对象返回值调用
 *
 *  @param target 调用目标
 *  @param _cmd   调用方法
 *  @param ...    参数
 *
 *  @return 返回OC对象
 */
id callbackDynamicMethodIMP(id target,SEL _cmd,...) {
    //处理参数
    AOP_CREATE_INVOCATION(_cmd);
    id returnValue = nil;
    execBeforeMethod(target, _cmd, invocation);
    execOrigMethod(target,_cmd,invocation);
    [invocation getReturnValue:&returnValue];
    execAfterMethod(target, _cmd, invocation);
    return returnValue;
}

#undef AOP_DEF_TYPE_FUNCTION
#define AOP_DEF_TYPE_FUNCTION( __type__ , __funcationName__ )                   \
__type__ __funcationName__(id target,SEL _cmd,...) {                            \
    AOP_CREATE_INVOCATION(_cmd);                                                \
    execBeforeMethod(target, _cmd, invocation);                                 \
    execOrigMethod(target,_cmd,invocation);                                     \
    __type__ returnValue;                                                       \
    [invocation getReturnValue:&returnValue];                                   \
    execAfterMethod(target, _cmd, invocation);                                  \
    return returnValue;                                                         \
}

AOP_DEF_TYPE_FUNCTION(char,CALLBACK_FUNCTION_NAME_char)

AOP_DEF_TYPE_FUNCTION(unsigned char,CALLBACK_FUNCTION_NAME_unsigned_char)

AOP_DEF_TYPE_FUNCTION(signed char,CALLBACK_FUNCTION_NAME_signed_char)

AOP_DEF_TYPE_FUNCTION(unichar,CALLBACK_FUNCTION_NAME_unichar)

AOP_DEF_TYPE_FUNCTION(short,CALLBACK_FUNCTION_NAME_short)

AOP_DEF_TYPE_FUNCTION(unsigned short,CALLBACK_FUNCTION_NAME_unsigned_short)

AOP_DEF_TYPE_FUNCTION(signed short,CALLBACK_FUNCTION_NAME_signed_short)

AOP_DEF_TYPE_FUNCTION(int, CALLBACK_FUNCTION_NAME_int)

AOP_DEF_TYPE_FUNCTION(unsigned int, CALLBACK_FUNCTION_NAME_unsigned_int)

AOP_DEF_TYPE_FUNCTION(signed int, CALLBACK_FUNCTION_NAME_signed_int)

AOP_DEF_TYPE_FUNCTION(long, CALLBACK_FUNCTION_NAME_long)

AOP_DEF_TYPE_FUNCTION(unsigned long, CALLBACK_FUNCTION_NAME_unsigned_long)

AOP_DEF_TYPE_FUNCTION(signed long,CALLBACK_FUNCTION_NAME_signed_long)

AOP_DEF_TYPE_FUNCTION(long long, CALLBACK_FUNCTION_NAME_long_long)

AOP_DEF_TYPE_FUNCTION(unsigned long long, CALLBACK_FUNCTION_NAME_unsigned_long_long)

AOP_DEF_TYPE_FUNCTION(signed long long, CALLBACK_FUNCTION_NAME_signed_long_long)

AOP_DEF_TYPE_FUNCTION(NSInteger,CALLBACK_FUNCTION_NAME_NSInteger)

AOP_DEF_TYPE_FUNCTION(NSUInteger, CALLBACK_FUNCTION_NAME_NSUInteger)

AOP_DEF_TYPE_FUNCTION(float, CALLBACK_FUNCTION_NAME_float)

AOP_DEF_TYPE_FUNCTION(CGFloat, CALLBACK_FUNCTION_NAME_CGFloat)

AOP_DEF_TYPE_FUNCTION(double, CALLBACK_FUNCTION_NAME_double)

AOP_DEF_TYPE_FUNCTION(BOOL,CALLBACK_FUNCTION_NAME_BOOL)

AOP_DEF_TYPE_FUNCTION(CGRect,CALLBACK_FUNCTION_NAME_CGRect)

AOP_DEF_TYPE_FUNCTION(CGPoint,CALLBACK_FUNCTION_NAME_CGPoint)

AOP_DEF_TYPE_FUNCTION(CGSize,CALLBACK_FUNCTION_NAME_CGSize)

AOP_DEF_TYPE_FUNCTION(UIEdgeInsets,CALLBACK_FUNCTION_NAME_UIEdgeInsets)

AOP_DEF_TYPE_FUNCTION(UIOffset,CALLBACK_FUNCTION_NAME_UIOffset)

AOP_DEF_TYPE_FUNCTION(CGVector,CALLBACK_FUNCTION_NAME_CGVector)


@interface ZWIntercepter (PRIVATE)
- (Class)intercepterClassForInterceptedClass:(Class)interceptedClass;
@end

typedef id (*InterceptedClassIMP) (id, SEL);

id getIntercepterDynamicMethodIMP(id interceptedInstance, SEL _cmd) {
    id intercepter = objc_getAssociatedObject(interceptedInstance, kZWIntercepterPropertyKey);
    if(intercepter == nil) {
        Class intercepterClass = [[ZWIntercepter sharedInstance] intercepterClassForInterceptedClass:[interceptedInstance class]];
        if(intercepterClass != nil) {
            intercepter = [[intercepterClass alloc] init];
            SEL setInterceptedInstanceSel = @selector(setInterceptedInstance:);
            if([intercepter respondsToSelector:setInterceptedInstanceSel]) {
                [intercepter performSelector:setInterceptedInstanceSel withObject:interceptedInstance];
            }
            objc_setAssociatedObject(interceptedInstance, kZWIntercepterPropertyKey, intercepter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return intercepter;
}



@implementation ZWIntercepter {
    NSMutableDictionary     *_intercepterClasses;
}

IMPLEMENTATION_SINGLETON(ZWIntercepter)
/**
 *  初始化AOP
 */
+ (void)setup {
    [ZWIntercepter sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _intercepterClasses = [NSMutableDictionary dictionary];
        [self setupInterceptedClasses];
    }
    return self;
}

#pragma mark - 私有方法 -
/**
 *  获取所有的拦截者
 *
 *  @return 返回拦截列表
 */
- (NSArray *)queryIntercepterClasses {
    NSMutableArray* intercepterClasses = [NSMutableArray array];
    int numClasses;
    Class * classes = NULL;
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0 )
    {
        Protocol* aopProtocol = @protocol(ZWIntercepterProtocol);
        
        classes = (Class *)malloc(sizeof(Class) * numClasses);
        
        numClasses = objc_getClassList(classes, numClasses);
        for (NSInteger i = 0; i < numClasses; i++)
        {
            Class cls = classes[i];
            
            for ( Class thisClass = cls; nil != thisClass ; thisClass = class_getSuperclass( thisClass ) )
            {
                if(class_conformsToProtocol(thisClass, aopProtocol)) {
                    [intercepterClasses addObject:cls];
                }
            }
        }
        free(classes);
    }
    
    return intercepterClasses;
}

/**
 *  初始化所有的注入的类
 */
- (void)setupInterceptedClasses {
    
    //查询所有定义注入的类
    NSArray* interceptedClasses = [self queryIntercepterClasses];
    
    //向注入器注册注入的类
    [interceptedClasses enumerateObjectsUsingBlock:^(id cls, NSUInteger idx, BOOL *stop) {
        [self setupIntercepter:cls];
    }];
}

/**
 *  安装拦截器
 *
 *  @param cls 拦截类
 */
- (void)setupIntercepter:(Class)cls {
    SEL getInterceptedClassSel = @selector(interceptedClass);
    Method getInterceptedClassMethod = class_getClassMethod(cls, getInterceptedClassSel);
    if(getInterceptedClassMethod == NULL) {
        return;
    }
    InterceptedClassIMP getInterceptedClassMethodIMP = (InterceptedClassIMP)method_getImplementation(getInterceptedClassMethod);
    Class interceptedClass = getInterceptedClassMethodIMP(cls,getInterceptedClassSel);
    [self registerIntercepterClass:cls forInterceptedClass:interceptedClass];
    [self setupIntercepterClass:cls forInterceptedClass:interceptedClass];
    [self interceptMethodsWithInterceptedClass:interceptedClass intercepter:cls];
}

/**
 *  为被拦截的类注册拦截器
 *
 *  @param intercepter      拦截类
 *  @param interceptedClass 被拦截的类
 */
- (void)registerIntercepterClass:(Class)intercepter forInterceptedClass:(Class)interceptedClass {
    [_intercepterClasses setObject:intercepter forKey:NSStringFromClass(interceptedClass)];
}

/**
 *  为被拦截的类安装拦截器
 *
 *  @param cls 被拦截的类
 */
- (void)setupIntercepterClass:(Class)intercepter forInterceptedClass:(Class)interceptedClass {
    class_addMethod(interceptedClass,NSSelectorFromString(GET_INTERCEPTER_METHOD_NAME), (IMP)getIntercepterDynamicMethodIMP, "@@:");
}

/**
 *  通过类获取所有方法
 *
 *  @param cls 类
 *
 *  @return 返回方法的集合
 */
- (NSArray*)methodsForClass:(Class)cls {
    NSMutableArray* methods = [NSMutableArray array];
    if(cls == nil) return methods;
    uint methodListCount = 0;
    Method* pArrMethods = class_copyMethodList(cls, &methodListCount);
    if(pArrMethods != NULL && methodListCount > 0) {
        for (int i = 0; i < methodListCount; i++) {
            SEL name = method_getName(pArrMethods[i]);
            NSString *methodName = [NSString  stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
            [methods addObject:methodName];
            
        }
        free((void *)pArrMethods);
    }
    return methods;
}

- (Class)intercepterClassForInterceptedClass:(Class)interceptedClass {
    return [_intercepterClasses objectForKey:NSStringFromClass(interceptedClass)];
}

/**
 *  通过拦截器拦截目标类
 *
 *  @param interceptedClass 目标拦截类
 *  @param intercepter      拦截器
 */
- (void)interceptMethodsWithInterceptedClass:(Class)interceptedClass
                                 intercepter:(Class)intercepter {
    NSArray* methods = [self methodsForClass:interceptedClass];
    [methods enumerateObjectsUsingBlock:^(NSString* methodName, NSUInteger idx, BOOL *stop) {
        if(![methodName isEqualToString:@"intercepter"]) {
            SEL beforeMethodSel = NSSelectorFromString([NSString stringWithFormat:@"%@%@",INTERCEPTER_BEFORE_METHOD_NAME,methodName]);
            SEL afterMethodSel = NSSelectorFromString([NSString stringWithFormat:@"%@%@",INTERCEPTER_AFTER_METHOD_NAME,methodName]);
            Method beforeMethod = class_getInstanceMethod(intercepter, beforeMethodSel);
            Method afterMethod = class_getInstanceMethod(intercepter, afterMethodSel);
            if(beforeMethod || afterMethod) {
                SEL originalMethodSel = NSSelectorFromString(methodName);
                SEL newOriginalMethodSel = NSSelectorFromString([NSString stringWithFormat:@"%@%@",ORIG_METHOD_PREFIX,methodName]);
                
                Method originalMethod = class_getInstanceMethod(interceptedClass, originalMethodSel);
                IMP  origMethodIMP = class_getMethodImplementation(interceptedClass, originalMethodSel);
                
                class_addMethod(interceptedClass, newOriginalMethodSel, origMethodIMP, method_getTypeEncoding(originalMethod));
                NSMethodSignature *sig = [interceptedClass instanceMethodSignatureForSelector:originalMethodSel];
                const char *returnType = sig.methodReturnType;
                if(!strcmp(returnType, @encode(void)) ){
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)vCallbackDynamicMethodIMP ,method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(id))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)callbackDynamicMethodIMP ,method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(char))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_char ,method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(unsigned char))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_unsigned_char,method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(signed char))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_signed_char,method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(unichar))) {
                   class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_unichar, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(short))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_short, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(unsigned short))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_unsigned_short, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(signed short))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_signed_short, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(int))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_int, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(unsigned int))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_unsigned_int, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(signed int))){
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_signed_int, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(long))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_long, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(unsigned long))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_unsigned_long, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(signed long))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_signed_long, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(long long))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_long_long, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(unsigned long long))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_unsigned_long_long, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(signed long long))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_signed_long_long, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(NSInteger))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_NSInteger, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(NSUInteger))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_NSUInteger, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(float))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_float, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(CGFloat))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_CGFloat, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(double))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_double, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(BOOL))) {
                   class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_BOOL, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(CGRect))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_CGRect, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(CGPoint))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_CGPoint, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(CGSize))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_CGSize, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(UIEdgeInsets))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_UIEdgeInsets, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(UIOffset))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_UIOffset, method_getTypeEncoding(originalMethod));
                } else if(!strcmp(returnType, @encode(CGVector))) {
                    class_replaceMethod(interceptedClass, originalMethodSel, (IMP)CALLBACK_FUNCTION_NAME_CGVector, method_getTypeEncoding(originalMethod));
                } else {
                    NSLog(@"not support return type ( %s ) in Class %@ => %@",method_getTypeEncoding(originalMethod),interceptedClass,methodName);
                }
            }
        }
    }];
}
@end