//
//  NSObject+GTTheme.m
//  GTThemeFramework
//
//  Created by 吴华林 on 2018/5/29.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import "NSObject+GTTheme.h"
#import <objc/runtime.h>
#import "GTThemeManager.h"
#import "GTObjectDeallocManager.h"
#import "GTThemeInvocationObject.h"
//安全的主线成执行
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif
@interface NSObject()
@property(nonatomic,strong)NSMutableDictionary<NSString *,NSMutableArray<GTThemeInvocationObject *> *> *pickerDict;
@end
@implementation NSObject (GTTheme)
#pragma mark public

- (void)gt_setThemeObjectsAndInvokeWithSeletor:(SEL)seletor params:(id _Nonnull)params,...NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *muAyOtherParams = [[NSMutableArray alloc] init];
    //1.先执行一下方法
    va_list args;
    va_start(args, params);
    void *tempParam = NULL;
    while((tempParam =va_arg(args, void *))!=NULL) {
        [muAyOtherParams addObject:[NSValue valueWithPointer:tempParam]];
    }
    //3.清空参数列表，
    va_end(args);
    dispatch_main_async_safe(^{
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:seletor];
    if(methodSignature) {
        //执行主题对应的
        [self invokeInvocationWithSeletor:seletor fristParams:params otherParams:muAyOtherParams];
       
        //2.缓存invocation
        [self cacheInvocationObjectWithSeletor:seletor fristParams:params otherParams:muAyOtherParams];
    }
        
    });
}
- (void)removeCacheThemeObjectsAndInvokeWithSeletor:(nonnull SEL)seletor  {
    [self.pickerDict removeObjectForKey:NSStringFromSelector(seletor)];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:seletor withObject:nil];
#pragma clang diagnostic pop
}
#pragma mark private_method

/**
 主题出现变化执行的方法
 */
- (void)gt_updateTheme {
    dispatch_main_async_safe(^{
        for(NSMutableArray *ayInvocation in [self.pickerDict allValues]) {
            NSUInteger currentThemeVersion = [GTThemeManager shareInstance].currentThemeVersion;
            if(ayInvocation.count > currentThemeVersion) {
                GTThemeInvocationObject *obj = ayInvocation[currentThemeVersion];
                [obj invoke];
            }
        }
   });
    
}

/**
 调用对应的主题对应的方法

 @param seletor 方法名
 @param params 第一个参数
 @param muAyOtherParams 其他参数的集合
 */
- (void)invokeInvocationWithSeletor:(SEL)seletor fristParams:(id)params otherParams:(NSMutableArray *)muAyOtherParams {
    
     NSMethodSignature *methodSignature = [self methodSignatureForSelector:seletor];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = self;
    invocation.selector = seletor;
    if(params) {
         NSUInteger themeVersion = [GTThemeManager shareInstance].currentThemeVersion;
        if([params isKindOfClass:[NSArray class]]) {
            //如果可变参数第一个参数是数组的时候
            NSArray *ayParams = (NSArray *)params;
            if(ayParams.count > themeVersion) {
                void *fristParam = (__bridge void *)(ayParams[themeVersion]);
                [self setArgumentToInvocation:invocation argument:&fristParam atIndex:2];
                for(int index=0;index<muAyOtherParams.count;index++) {
                    void *tempParam = [muAyOtherParams[index] pointerValue];
                    [self setArgumentToInvocation:invocation argument:&tempParam atIndex:index+3];
                }
                
            }
        } else {
            //如果可变参数第一个不是数组的时候（需要判断参数类型是否相符）
            [self setArgumentToInvocation:invocation argument:(void *)&params atIndex:2];
            for(int index=0;index<muAyOtherParams.count;index++) {
                void *tempParam = [muAyOtherParams[index] pointerValue];
                [self setArgumentToInvocation:invocation argument:&tempParam atIndex:index+3];
            }
        }
        
    }
    [invocation invoke];
}

/**
 缓存所有的主题的对应的Invocation

 @param seletor 方法名
 @param params 第一个参数
 @param muAyOtherParams 其他参数的集合
 */
- (void)cacheInvocationObjectWithSeletor:(SEL)seletor fristParams:(id)params otherParams:(NSMutableArray *)muAyOtherParams {
    if(params) {
        if([params isKindOfClass:[NSArray class]]) {
            NSArray *ayParams = (NSArray *)params;
            for(NSUInteger i=0;i<ayParams.count;i++) {
                NSMutableArray*ayInvocation = [self getAyInvocationFromSeletor:seletor];
                //构造NSInvocation
                GTThemeInvocationObject *invocationObject = [[GTThemeInvocationObject alloc] initWithTarget:self selector:seletor];
                id firstParam = ayParams[i];
                [invocationObject setArgument:firstParam atIndex:2];
                
                for(int index=0;index<muAyOtherParams.count;index++) {
                    void *tempParam = [muAyOtherParams[index] pointerValue];
                    if(strcmp([invocationObject.methodSignature getArgumentTypeAtIndex:index+3], "Q") == 0) {
                        NSNumber *number = [NSNumber numberWithUnsignedInteger:(NSUInteger)tempParam];
                        [invocationObject setArgument:number atIndex:index+3];
                    } else {
                        [invocationObject setArgument:CFBridgingRelease(tempParam) atIndex:index+3];
                    }
                    
                }
                [ayInvocation addObject:invocationObject];
            }
        } else {
            //可变参数第一个不是数组的时候
            NSMutableArray*ayInvocation = [self getAyInvocationFromSeletor:seletor];
            //构造NSInvocation
            GTThemeInvocationObject *invocationObject = [[GTThemeInvocationObject alloc] initWithTarget:self selector:seletor];
            id firstParam = params;
             [invocationObject setArgument:firstParam atIndex:2];
            
            for(int index=0;index<muAyOtherParams.count;index++) {
                void *tempParam = [muAyOtherParams[index] pointerValue];
                [invocationObject setArgument:CFBridgingRelease(tempParam) atIndex:index+3];
            }
            [ayInvocation addObject:invocationObject];
        }
    } else {
        NSMutableArray*ayInvocation = [self getAyInvocationFromSeletor:seletor];
        //构造NSInvocation
        GTThemeInvocationObject *invocationObject = [[GTThemeInvocationObject alloc] initWithTarget:self selector:seletor];
        [ayInvocation addObject:invocationObject];
    }
}
- (void)setArgumentToInvocation:(NSInvocation *)invocation argument:(void *)argument atIndex:(NSInteger)index {
    if(invocation){
        if(index>1 && index< [invocation methodSignature].numberOfArguments && argument!=NULL) {
            [invocation setArgument:argument atIndex:index];
        }
    }
}
#pragma mark set/get
- (NSMutableArray *)getAyInvocationFromSeletor:(SEL)seletor {
    NSString *strSeletor = NSStringFromSelector(seletor);
    NSMutableArray*ayInvocation = self.pickerDict[strSeletor];
    if(!ayInvocation) {
        ayInvocation = [[NSMutableArray alloc] init];
        [self.pickerDict setObject:ayInvocation forKey:strSeletor];
    }
    return ayInvocation;
}
- (NSMutableDictionary<NSString *,NSMutableArray<NSInvocation *> *> *)pickerDict {
    
    NSMutableDictionary<NSString *,NSMutableArray<NSInvocation *> *> *pickerDict = objc_getAssociatedObject(self, @selector(pickerDict));
    if(!pickerDict) {
        @autoreleasepool {
            GTObjectDeallocManager *manager = objc_getAssociatedObject(self, "GTObjectDeallocManager");
            __weak typeof(self) weakSelf = self;
            if(!manager) {
                manager= [[GTObjectDeallocManager alloc] init];
                [manager addDeallocBlock:^{
                    if(weakSelf) {
                        [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                    }
                }];
                objc_setAssociatedObject(self, "GTObjectDeallocManager", manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            
        }
        pickerDict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(pickerDict), pickerDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GTThemeVersionChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gt_updateTheme) name:GTThemeVersionChangeNotification object:nil];
    }
    return pickerDict;
}
@end

