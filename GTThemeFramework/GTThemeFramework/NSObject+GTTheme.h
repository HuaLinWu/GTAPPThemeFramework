//
//  NSObject+GTTheme.h
//  GTThemeFramework
//
//  Created by 吴华林 on 2018/5/29.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSObject (GTTheme)
/**
 设置主题(并且会根据当前主题去调用一个对应的方法)

 @param seletor 针对本对象某一个方法
 @param params 方法需要的参数
 */
- (void)gt_setThemeObjectsAndInvokeWithSeletor:(nonnull SEL)seletor params:(id)params,...NS_REQUIRES_NIL_TERMINATION;

/**
 针对某个方法移除主题设置

 @param seletor 对应的方法
 */
- (void)removeCacheThemeObjectsAndInvokeWithSeletor:(nonnull SEL)seletor;
@end
