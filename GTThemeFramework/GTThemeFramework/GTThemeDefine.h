//
//  GTThemeDefine.h
//  GTThemeFramework
//
//  Created by 吴华林 on 2018/5/29.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#ifndef GTThemeDefine_h
#define GTThemeDefine_h
//主题变化的通知
#define GTThemeVersionChangeNotification @"GTThemeVersionChangeNotification"

/**
 设置对象属性的方法调用

 @param OBJ 对象
 @param PATH 数显
 @return 返回
 */
#define GTThemeSetValuesForProperty(OBJ,PATH,...)\
((void)(NO && ((void)OBJ.PATH, NO)),\
[OBJ gt_setThemeObjectsWithSeletor:@selector(setValue:forKey:) params:__VA_ARGS__,@(#PATH),nil])

/**
 主题的枚举

 - GTDayVersion: 白天
 - GTNightVersion: 黑夜
 */
typedef NS_ENUM(NSUInteger,GTThemeVersion) {
    GTDayVersion,
    GTNightVersion
};

#endif /* GTThemeDefine_h */
