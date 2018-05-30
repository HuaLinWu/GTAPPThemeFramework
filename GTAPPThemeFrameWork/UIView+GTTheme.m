//
//  UIView+GTTheme.m
//  GTAPPThemeChanage
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import "UIView+GTTheme.h"
#import "NSObject+GTTheme.h"
#import "GTThemeManager.h"
@implementation UIView (GTTheme)
- (void)gt_setBackgroundColors:(NSArray <UIColor *>*)colors {
    if(colors.count >[GTThemeManager shareInstance].currentThemeVersion) {
        UIColor *color = [colors objectAtIndex:[GTThemeManager shareInstance].currentThemeVersion];
        [self setBackgroundColor:color];
    }
     //缓存
    [self cacheThemeObjectsWithSelector:@selector(setBackgroundColor:) fristArguments:colors];
}
- (void)gt_setTineColors:(NSArray<UIColor *> *)colors {
    
    if(colors.count >[GTThemeManager shareInstance].currentThemeVersion) {
        UIColor *color = [colors objectAtIndex:[GTThemeManager shareInstance].currentThemeVersion];
        [self setTintColor:color];
    }
    //缓存
     [self cacheThemeObjectsWithSelector:@selector(setTintColor:) fristArguments:colors];
}
@end
