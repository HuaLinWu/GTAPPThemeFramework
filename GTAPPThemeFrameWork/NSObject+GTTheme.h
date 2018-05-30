//
//  NSObject+GTTheme.h
//  GTAPPThemeChanage
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (GTTheme)
/**
 缓存主题相关的方法和对应的参数集合

 @param selector 方法SEL
 @param objects 不同主题对应不同参数的集合
 warning 这个方法只是针对只有一个参数的SEL(这是框架使用的不是其他人不得使用)
 */
- (void)cacheThemeObjectsWithSelector:(SEL)selector fristArguments:(NSArray *)objects;

/**
 缓存主题相关的方法和对应的参数集合

 @param selector 方法SEL
 @param fristArguments 第一个参数的集合
 @param secondArguments 第二个参数的集合
 */
- (void)cacheThemeObjectsWithSelector:(SEL)selector fristArguments:(NSArray *)fristArguments secondArguments:(NSArray *)secondArguments;
@end
