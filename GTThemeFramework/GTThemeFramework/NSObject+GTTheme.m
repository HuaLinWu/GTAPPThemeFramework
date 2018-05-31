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
@interface NSObject()
@property(nonatomic,strong)NSMutableDictionary<NSString *,NSMutableArray<NSInvocation *> *> *pickerDict;
@end
@implementation NSObject (GTTheme)
#pragma mark public
- (void)cacheThemeObjectsWithSeletor:(SEL)seletor fristParams:(NSArray *)firstParams {
    if(!seletor || !firstParams || ![firstParams isKindOfClass:[NSArray class]]) return;
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:seletor];
    if(methodSignature) {
        for(NSUInteger i=0;i<firstParams.count;i++) {
            NSString *themeVersion = [NSString stringWithFormat:@"%li",i];
            NSMutableArray*ayInvocation = self.pickerDict[themeVersion];
            if(!ayInvocation) {
                ayInvocation = [[NSMutableArray alloc] init];
                [self.pickerDict setObject:ayInvocation forKey:themeVersion];
            }
            //构造NSInvocation
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            invocation.target = self;
            invocation.selector = seletor;
            id param = firstParams[i];
            [invocation setArgument:&param atIndex:2];
            [ayInvocation addObject:invocation];
        }
    }
}
- (void)cacheThemeObjectsWithSeletor:(SEL)seletor fristParams:(NSArray *)firstParams secondParams:(NSArray *)secondParams {
    
    if(!seletor || !firstParams || ![firstParams isKindOfClass:[NSArray class]] || ![secondParams isKindOfClass:[NSArray class]] || firstParams.count !=secondParams.count) return;
    
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:seletor];
    if(methodSignature) {
        for(NSUInteger i=0;i<firstParams.count;i++) {
            NSString *themeVersion = [NSString stringWithFormat:@"%li",i];
            NSMutableArray*ayInvocation = self.pickerDict[themeVersion];
            if(!ayInvocation) {
                ayInvocation = [[NSMutableArray alloc] init];
                [self.pickerDict setObject:ayInvocation forKey:themeVersion];
            }
            //构造NSInvocation
            
            NSInvocation *invocation = [[NSInvocation alloc] init];
            invocation.target = self;
            invocation.selector = seletor;
            id firstParam = firstParams[i];
            [invocation setArgument:&firstParam atIndex:2];
            
            id secondParam = secondParams[i];
            if(strcmp([methodSignature getArgumentTypeAtIndex:3], "Q") ==0) {
                NSUInteger temoSecond = [secondParam unsignedIntegerValue];
                [invocation setArgument:&temoSecond atIndex:3];
                
            } else {
                 [invocation setArgument:&secondParam atIndex:3];
            }
           
            [ayInvocation addObject:invocation];
        }
    }
}
- (void)gt_setThemeObjectsWithSeletor:(SEL)seletor fristParams:(NSArray *)firstParams secondParams:(NSArray *)secondParams{
    NSUInteger themeVersion = [GTThemeManager shareInstance].currentThemeVersion;
    
    if(!firstParams || ![firstParams isKindOfClass:[NSArray class]] || firstParams.count <=themeVersion || ![self respondsToSelector:seletor]) return;
    
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:seletor];
    
    id first = firstParams[themeVersion];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = self;
    invocation.selector = seletor;
    [invocation setArgument:&first atIndex:2];
    
    if ([methodSignature numberOfArguments] > 3) {
        if (!secondParams || ![secondParams isKindOfClass:[NSArray class]] || secondParams.count <=themeVersion || secondParams.count != firstParams.count) {
            return;
        }else{
            id second = secondParams[themeVersion];
            
            if(strcmp([methodSignature getArgumentTypeAtIndex:3], "Q") ==0) {
                NSUInteger temoSecond = [second unsignedIntegerValue];
                [invocation setArgument:&temoSecond atIndex:3];
            } else {
                [invocation setArgument:&second atIndex:3];
            }
            [invocation invoke];
            [self cacheThemeObjectsWithSeletor:seletor fristParams:firstParams secondParams:secondParams];
        }
    }else{
        [invocation invoke];
        [self cacheThemeObjectsWithSeletor:seletor fristParams:firstParams];
    }
}
#pragma mark private_method
- (void)gt_updateTheme {
    NSString *themeVersion = [NSString stringWithFormat:@"%li",[GTThemeManager shareInstance].currentThemeVersion];
    NSMutableArray *ayInvocation = self.pickerDict[themeVersion];
    [ayInvocation enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj invoke];
    }];
    
}
#pragma mark set/get
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
