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
 设置主题

 @param seletor 针对本对象某一个方法
 @param params 方法需要的参数
 */
- (void)gt_setThemeObjectsWithSeletor:(nonnull SEL)seletor params:(id)params,...NS_REQUIRES_NIL_TERMINATION;
@end
