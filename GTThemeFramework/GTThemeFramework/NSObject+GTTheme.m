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
@property(nonatomic,strong)NSMutableDictionary<NSString *,NSMutableArray<NSInvocation *> *> *pickerDict;
@end
@implementation NSObject (GTTheme)
#pragma mark public

- (void)gt_setThemeObjectsWithSeletor:(SEL)seletor params:(id _Nonnull)params,...NS_REQUIRES_NIL_TERMINATION {
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
    NSUInteger themeVersion = [GTThemeManager shareInstance].currentThemeVersion;
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:seletor];
    if(methodSignature) {
        
        NSInvocation *invocation = [self createInvocationWithSeletor:seletor];
        if(params) {
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
        //2.缓存invocation
        if(params) {
            if([params isKindOfClass:[NSArray class]]) {
                NSArray *ayParams = (NSArray *)params;
                for(NSUInteger i=0;i<ayParams.count;i++) {
                    NSMutableArray*ayInvocation = [self getAyInvocationFromThemeVersion:i];
                    //构造NSInvocation
                    NSInvocation *invocation = [self createInvocationWithSeletor:seletor];
                    id firstParam = ayParams[i];
                    [self setArgumentToInvocation:invocation argument:&firstParam atIndex:2];
    
                    for(int index=0;index<muAyOtherParams.count;index++) {
                        void *tempParam = [muAyOtherParams[index] pointerValue];
                        [self setArgumentToInvocation:invocation argument:&tempParam atIndex:index+3];
                    }
                    [ayInvocation addObject:invocation];
                }
            } else {
                //可变参数第一个不是数组的时候
                NSMutableArray*ayInvocation = [self getAyInvocationFromThemeVersion:0];
                //构造NSInvocation
                NSInvocation *invocation = [self createInvocationWithSeletor:seletor];
                id firstParam = params;
                [self setArgumentToInvocation:invocation argument:&firstParam atIndex:2];
                
                for(int index=0;index<muAyOtherParams.count;index++) {
                    void *tempParam = [muAyOtherParams[index] pointerValue];
                    [self setArgumentToInvocation:invocation argument:&tempParam atIndex:index+3];
                }
                [ayInvocation addObject:invocation];
            }
        } else {
            NSMutableArray*ayInvocation = [self getAyInvocationFromThemeVersion:0];
            //构造NSInvocation
            NSInvocation *invocation = [self createInvocationWithSeletor:seletor];
            [ayInvocation addObject:invocation];
        }
    }
        
    });
}
#pragma mark private_method
- (void)gt_updateTheme {
    NSString *themeVersion = [NSString stringWithFormat:@"%lu",(unsigned long)[GTThemeManager shareInstance].currentThemeVersion];
    NSMutableArray *ayInvocation = self.pickerDict[themeVersion];
    dispatch_main_async_safe(^{
        [ayInvocation enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj invoke];
        }];
    });
    
}
- (NSInvocation *)createInvocationWithSeletor:(SEL)seletor {
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:seletor];
    NSInvocation *invocation = nil;
    if(methodSignature) {
        invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.target = self;
        invocation.selector = seletor;
    }
    return invocation;
}
- (void)setArgumentToInvocation:(NSInvocation *)invocation argument:(void *)argument atIndex:(NSInteger)index {
    if(invocation){
        if(index>1 && index< [invocation methodSignature].numberOfArguments && argument!=NULL) {
            [invocation setArgument:argument atIndex:index];
        }
    }
}
#pragma mark set/get
- (NSMutableArray *)getAyInvocationFromThemeVersion:(GTThemeVersion)themeVersion {
    NSString *strThemeVersion = [NSString stringWithFormat:@"%lu",(unsigned long)themeVersion];
    NSMutableArray*ayInvocation = self.pickerDict[strThemeVersion];
    if(!ayInvocation) {
        ayInvocation = [[NSMutableArray alloc] init];
        [self.pickerDict setObject:ayInvocation forKey:strThemeVersion];
    }
    return ayInvocation;
}
- (NSMutableDictionary<NSString *,NSMutableArray<NSInvocation *> *> *)pickerDict {
    
    NSMutableDictionary<NSString *,NSMutableArray<NSInvocation *> *> *pickerDict = objc_getAssociatedObject(self, @selector(pickerDict));
    if(!pickerDict) {
        @autoreleasepool {
            GTObjectDeallocManager *manager = objc_getAssociatedObject(self, "GTObjectDeallocManager");
            __unsafe_unretained typeof(self) weakSelf = self;
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

