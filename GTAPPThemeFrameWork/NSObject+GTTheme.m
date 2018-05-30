//
//  NSObject+GTTheme.m
//  GTAPPThemeChanage
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import "NSObject+GTTheme.h"
#import <objc/runtime.h>
#import "GTThemeManager.h"
#import "NSObjectDellocManager.h"
@interface NSObject()
@property(nonatomic,strong)NSMutableDictionary<NSString *,NSMutableArray<NSInvocation *> *>*pickerDict;
@end
@implementation NSObject (GTTheme)
#pragma mark public_method
- (void)cacheThemeObjectsWithSelector:(SEL)selector fristArguments:(NSArray *)objects {
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
    if(methodSignature) {
        for(int i=0;i<objects.count;i++) {
            //取出主题对应的集合
            NSString *themeVersion = [NSString stringWithFormat:@"%i",i];
            NSMutableArray *ayInvocation = [self.pickerDict objectForKey:themeVersion];
            if(!ayInvocation) {
                ayInvocation = [[NSMutableArray alloc] init];
                [self.pickerDict setObject:ayInvocation forKey:themeVersion];
            }
            //取出参数放入
            id object= objects[i];
            //构造invocation
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            invocation.target = self;
            invocation.selector = selector;
            [invocation setArgument:(void *)&object atIndex:2];
            [ayInvocation addObject:invocation];
        }
    }
}
- (void)cacheThemeObjectsWithSelector:(SEL)selector fristArguments:(NSArray *)fristArguments secondArguments:(NSArray *)secondArguments {
    if(!fristArguments||!secondArguments||![fristArguments isKindOfClass:[NSArray class]]||![secondArguments isKindOfClass:[NSArray class]]||fristArguments.count !=secondArguments.count) return;
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
    if(methodSignature) {
        for(int i=0;i<fristArguments.count;i++) {
            //取出主题对应的集合
            NSString *themeVersion = [NSString stringWithFormat:@"%i",i];
            NSMutableArray *ayInvocation = [self.pickerDict objectForKey:themeVersion];
            if(!ayInvocation) {
                ayInvocation = [[NSMutableArray alloc] init];
                [self.pickerDict setObject:ayInvocation forKey:themeVersion];
            }
            //取出参数放入
            id fristObject= fristArguments[i];
            id secondObject = secondArguments[i];
            //构造invocation
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            invocation.target = self;
            invocation.selector = selector;
            [invocation setArgument:(void *)&fristObject atIndex:2];
            const char *secondArgumentType = [methodSignature getArgumentTypeAtIndex:3];
            if(strcmp(secondArgumentType, "Q")==0) {
                //表示An unsigned long long
                NSUInteger  unsignedIntegerValue = [secondObject unsignedIntegerValue];
                [invocation setArgument:(void *)&unsignedIntegerValue atIndex:3];
            } else {
                [invocation setArgument:(void *)&secondObject atIndex:3];
            }
            
            [ayInvocation addObject:invocation];
        }
    }
}
#pragma mark private_method
- (void)update_Theme {
    NSMutableArray <NSInvocation *>*ayThemeInvocations = [self.pickerDict valueForKey:[NSString stringWithFormat:@"%li",(long)[GTThemeManager shareInstance].currentThemeVersion]];
    [ayThemeInvocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj invoke];
    }];
}
#pragma mark set/get
- (NSMutableDictionary<NSString *,NSMutableArray<NSInvocation *> *> *)pickerDict {
  
   NSMutableDictionary<NSString *,NSMutableArray<NSInvocation *> *>*pickerDict = objc_getAssociatedObject(self, "ayTheme");
    if(!pickerDict){
        @autoreleasepool {
            NSObjectDellocManager *deallocManager = objc_getAssociatedObject(self, "deallocManager");
            __unsafe_unretained typeof(self) weakSelf = self;
            if(!deallocManager) {
                deallocManager = [[NSObjectDellocManager alloc] init];
                [deallocManager addDeallocBlock:^{
                    [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                }];
                objc_setAssociatedObject(self, "deallocManager", deallocManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            pickerDict = [[NSMutableDictionary alloc] init];
            objc_setAssociatedObject(self, "ayTheme", pickerDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [[NSNotificationCenter defaultCenter] removeObserver:self name:GTThemeChanageNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update_Theme) name:GTThemeChanageNotification object:nil];
        }
    }
    return pickerDict;
}
@end
