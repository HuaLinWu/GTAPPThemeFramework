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
#import <UIKit/UIKit.h>
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

- (void)gt_setThemeObjectsAndInvokeWithSeletor:(SEL)seletor params:(id _Nullable)params,...NS_REQUIRES_NIL_TERMINATION {
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
- (void)gt_removeCacheThemeObjectsWithSeletor:(nonnull SEL)seletor  {
    [self.pickerDict removeObjectForKey:NSStringFromSelector(seletor)];
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
- (void)invokeInvocationWithSeletor:(SEL)seletor params:(NSArray *)params {
    
//    dispatch_main_async_safe(^{
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
                
                NSValue *value = [self getSafeArgument:invocationArgument targetArgumentType:argumentType];
                
                void *tempInvocationArgument = NULL;
                
                if (strcmp(argumentType, "@") == 0) {
                    id object = nil;
                    if([value respondsToSelector:@selector(getValue:size:)]) {
                        
                        [value getValue:&object size:sizeof(id)];
                        
                    } else if ([value respondsToSelector:@selector(getValue:)]) {
                        
                        [value getValue:&object];
                    }
                    tempInvocationArgument = &object;
                    
                } else if (strcmp(argumentType, "^{CGColor=}")==0) {
                    
                    CGColorRef color = NULL;
                    if([value respondsToSelector:@selector(getValue:size:)]) {
                        
                        [value getValue:&color size:sizeof(CGColorRef)];
                        
                    } else if ([value respondsToSelector:@selector(getValue:)]) {
                        
                        [value getValue:&color];
                    }
                    tempInvocationArgument = &color;
                    
                } else if (strcmp(argumentType, "Q") == 0) {
                    NSUInteger uInteger = 0;
                    if([value respondsToSelector:@selector(getValue:size:)]) {
                        
                        [value getValue:&uInteger size:sizeof(NSUInteger)];
                        
                    } else if ([value respondsToSelector:@selector(getValue:)]) {
                        
                        [value getValue:&uInteger];
                    }
                     tempInvocationArgument = &uInteger;
                    
                } else if (strcmp(argumentType, "B")==0) {
                    
                    BOOL boolValue = NO;
                    if([value respondsToSelector:@selector(getValue:size:)]) {
                        
                        [value getValue:&boolValue size:sizeof(BOOL)];
                        
                    } else if ([value respondsToSelector:@selector(getValue:)]) {
                        
                        [value getValue:&boolValue];
                    }
                    tempInvocationArgument = &boolValue;
                    
                } else if (strcmp(argumentType, "{CGRect={CGPoint=dd}{CGSize=dd}}")==0) {
                    CGRect rect = CGRectZero;
                    if([value respondsToSelector:@selector(getValue:size:)]) {
                        
                        [value getValue:&rect size:sizeof(CGRect)];
                        
                    } else if ([value respondsToSelector:@selector(getValue:)]) {
                        
                        [value getValue:&rect];
                    }
                    tempInvocationArgument = &rect;
                    
                } else if (strcmp(argumentType, "i") == 0) {
                    int intValue = 0;
                    if([value respondsToSelector:@selector(getValue:size:)]) {
                        
                        [value getValue:&intValue size:sizeof(int)];
                        
                    } else if ([value respondsToSelector:@selector(getValue:)]) {
                        
                        [value getValue:&intValue];
                    }
                    tempInvocationArgument = &intValue;
                } if(strcmp(argumentType, "c") == 0) {
                    
                } else if (strcmp(argumentType, "s") == 0) {
                    
                } else if (strcmp(argumentType, "l") == 0) {
                    
                } else if (strcmp(argumentType, "q") == 0) {
                    
                } else if (strcmp(argumentType, "C") == 0) {
                    
                } else if (strcmp(argumentType, "I") == 0) {
                    
                } else if (strcmp(argumentType, "S") == 0) {
                    
                } else if (strcmp(argumentType, "L") == 0) {
                    
                } else if (strcmp(argumentType, "f") == 0) {
                    
                } else if (strcmp(argumentType, "d") == 0) {
                    
                } else if (strcmp(argumentType, "#") == 0) {
                    
                } else if (strcmp(argumentType, ":")==0) {
                    
                } else if (strcmp(argumentType, "?")) {
                    
                } else if (strcmp(argumentType, "*")) {
                    
                }
                [invocation setArgument:tempInvocationArgument atIndex:index];
                
            }
            [invocation invoke];
        }//});
}
- (void)logArgumentErrorMessage{
#ifdef DEBUG
    NSLog(@"参数出错了");
#endif
}
#pragma mark set/get
- (NSMutableArray *)getAyParamsFromSeletor:(SEL)seletor {
    NSString *strSeletor = NSStringFromSelector(seletor);
    NSMutableArray*ayParams = self.pickerDict[strSeletor];
    if(!ayParams) {
        ayParams = [[NSMutableArray alloc] init];
        [self.pickerDict setObject:ayParams forKey:strSeletor];
    } else {
        [ayParams removeAllObjects];
    }
    return ayParams;
}
- (NSValue *)getSafeArgument:(id)invocationArgument targetArgumentType:(const char *)argumentType {
    
    NSValue *returnValue = nil;
    if(strcmp(argumentType, "Q")==0) {
        //NSUInteger 类型
        if([invocationArgument isKindOfClass:[NSNumber class]]) {
            
            NSUInteger iArgument = [invocationArgument unsignedIntegerValue];
            returnValue = [NSValue value:&iArgument withObjCType:"Q"];
            
        } else {
            
            [self logArgumentErrorMessage];
        }
        
    } else if(strcmp(argumentType,"@")==0){
        //NSObject 类型
        if([invocationArgument isKindOfClass:[NSObject class]]) {
            
            returnValue = [NSValue value:&invocationArgument withObjCType:"@"];
            
        } else {
            
            [self logArgumentErrorMessage];
        }
    } else if (strcmp(argumentType, "^{CGColor=}")==0) {
        //CGColor 类型
        if([invocationArgument isKindOfClass:[UIColor class]]) {
            
            UIColor *tempColor = (UIColor *)invocationArgument;
            CGColorRef color = tempColor.CGColor;
            returnValue = [NSValue value:&color withObjCType:"^{CGColor=}"];
            
        } else if(sizeof(invocationArgument) == sizeof(CGColorRef)){
            
            returnValue= [NSValue value:&invocationArgument withObjCType:"^{CGColor=}"];
            
        } else {
            
            [self logArgumentErrorMessage];
        }
        
    } else if (strcmp(argumentType, "B")==0) {
        //bool 类型的
        if([invocationArgument isKindOfClass:[NSNumber class]]) {
            
            BOOL iArgument = [(NSNumber *)invocationArgument boolValue];
            returnValue = [NSValue value:&iArgument withObjCType:"B"];
            
        } else if([invocationArgument isKindOfClass:[NSString class]]) {
            
            BOOL iArgument = [(NSString *)invocationArgument boolValue];
             returnValue = [NSValue value:&iArgument withObjCType:"B"];
            
        } else {
            
             [self logArgumentErrorMessage];
        }
    } else if (strcmp(argumentType, "{CGRect={CGPoint=dd}{CGSize=dd}}")==0) {
        
        CGRect rect = CGRectZero;
        if([invocationArgument isKindOfClass:[NSValue class]]) {
            
            rect = ((NSValue *)invocationArgument).CGRectValue;
            returnValue = [NSValue value:&rect withObjCType:"{CGRect={CGPoint=dd}{CGSize=dd}}"];
            
        } else if([invocationArgument isKindOfClass:[NSString class]]) {
            
            rect = CGRectFromString(invocationArgument);
            returnValue = [NSValue value:&rect withObjCType:"{CGRect={CGPoint=dd}{CGSize=dd}}"];
            
        } else {
            [self logArgumentErrorMessage];
        }
        
    }
    else {
        returnValue = [NSValue value:&invocationArgument withObjCType:argumentType];
    }
    return returnValue;
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

