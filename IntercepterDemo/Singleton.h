//
//  Singleton.h
//  单例模式
//
//  Created by Apple on 16/6/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

#define Singleton_h(name) +(instancetype)shared##name;

#if __has_feature(objc_arc)
#define Singleton_m(name) static id instance; \
+(instancetype)shared##name{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[self alloc] init]; \
}); \
\
return instance; \
} \
\
+(instancetype)allocWithZone:(struct _NSZone *)zone{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [super allocWithZone:zone]; \
}); \
\
return instance; \
} \
\
-(id)copyWithZone:(NSZone *)zone{ \
return instance; \
}
#else
#define Singleton_m(name) static id instance; \
+(instancetype)shared##name{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[self alloc] init]; \
}); \
\
return instance; \
} \
\
+(instancetype)allocWithZone:(struct _NSZone *)zone{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [super allocWithZone:zone]; \
}); \
\
return instance; \
} \
\
-(id)copyWithZone:(NSZone *)zone{ \
return instance; \
} \
-(oneway void)release{ \
 \
} \
 \
-(instancetype)autorelease{ \
    return instance; \
} \
 \
-(instancetype)retain{ \
    return instance; \
} \
 \
-(NSUInteger)retainCount{ \
    return 1; \
}
#endif

