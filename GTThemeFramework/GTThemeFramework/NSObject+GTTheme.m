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
@property(nonatomic,strong)NSMutableDictionary<NSString *,NSMutableArray<id> *> *pickerDict;
@end
@implementation NSObject (GTTheme)
#pragma mark public

- (void)gt_setThemeObjectsAndInvokeWithSeletor:(SEL)seletor params:(id _Nonnull)params,...NS_REQUIRES_NIL_TERMINATION {
    //获取已有的参数列表数组，如果不存在就新建一个
    NSMutableArray *mutableAyParams = [self getAyParamsFromSeletor:seletor];
    if(params) {
        [mutableAyParams addObject:params];
    }
    //1.先执行一下方法
    va_list args;
    va_start(args, params);
    id tempParam = va_arg(args, id);
    while(tempParam !=NULL) {
        [mutableAyParams addObject:tempParam];
        tempParam = va_arg(args, id);
    }
    //3.清空参数列表，
    va_end(args);
    //执行主题对应的
    [self invokeInvocationWithSeletor:seletor params:mutableAyParams];
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
    
    for(NSString *key in [self.pickerDict allKeys]) {
        SEL seletor = NSSelectorFromString(key);
        NSMutableArray *params = self.pickerDict[key];
        [self invokeInvocationWithSeletor:seletor params:params];
    }
    
}

/**
 调用对应的主题对应的方法

 @param seletor 方法名
 @param params 参数
 */
- (void)invokeInvocationWithSeletor:(SEL)seletor params:(NSMutableArray *)params {
    
   dispatch_main_async_safe(^{
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:seletor];
    if(methodSignature) {
        //当前的主题的版本
        NSUInteger currentThemeVersion = [GTThemeManager shareInstance].currentThemeVersion;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.target = self;
        invocation.selector = seletor;
        for(int i=0;i<params.count&&i<(methodSignature.numberOfArguments-2);i++) {
            id param = params[i];
            NSUInteger index = 2+i;
            //invocationArgument
            id invocationArgument = nil;
            if([param isKindOfClass:[NSArray class]]) {
                
                NSArray *ayParam = (NSArray *)param;
                if(ayParam.count >currentThemeVersion) {
                    invocationArgument = ayParam[currentThemeVersion];
                }
            } else {
                invocationArgument = param;
            }
            //
            const char *argumentType = [methodSignature getArgumentTypeAtIndex:index];
            if(strcmp(argumentType, "Q")==0) {
                NSUInteger iArgument = [invocationArgument unsignedIntegerValue];
                 [invocation setArgument:&iArgument atIndex:index];
            } else if(strcmp(argumentType,"@")==0){
                [invocation setArgument:&invocationArgument atIndex:index];
            }
        }
        [invocation invoke];
    }});
}
#pragma mark set/get
- (NSMutableArray *)getAyParamsFromSeletor:(SEL)seletor {
    NSString *strSeletor = NSStringFromSelector(seletor);
    NSMutableArray*ayParams = self.pickerDict[strSeletor];
    if(!ayParams) {
        ayParams = [[NSMutableArray alloc] init];
        [self.pickerDict setObject:ayParams forKey:strSeletor];
    }
    return ayParams;
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

