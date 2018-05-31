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
 缓存主题

 @param seletor 设置方法
 @param firstParams firstParams 数组中下标和GTThemeVersion 一一对应的
 */
- (void)cacheThemeObjectsWithSeletor:(SEL)seletor fristParams:(NSArray *)firstParams;


/**
 缓存主题
 @param seletor 设置方法
 @param firstParams 数组中下标和GTThemeVersion 一一对应的
 @param secondParams 数组中下标和GTThemeVersion 一一对应的,为nil表示没有这个参数
 */
- (void)cacheThemeObjectsWithSeletor:(SEL)seletor fristParams:(NSArray *)firstParams secondParams:(NSArray *)secondParams;

/**
 设置主题
 @param seletor 设置方法
 @param firstParams 数组中下标和GTThemeVersion 一一对应的
 @param secondParams 数组中下标和GTThemeVersion 一一对应的,为nil表示没有这个参数
 */
- (void)gt_setThemeObjectsWithSeletor:(SEL)seletor fristParams:(NSArray *)firstParams secondParams:(NSArray *)secondParams;

@end
