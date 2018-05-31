//
//  UILabel+GTTheme.m
//  GTAPPThemeFrameWork
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import "UILabel+GTTheme.h"
#import "NSObject+GTTheme.h"
#import "GTThemeManager.h"
@implementation UILabel (GTTheme)
- (void)gt_setTextColors:(NSArray<UIColor *> *)colors {
    if(colors.count >[GTThemeManager shareInstance].currentThemeVersion) {
        UIColor *color = [colors objectAtIndex:[GTThemeManager shareInstance].currentThemeVersion];
        [self setTextColor:color];
    }
    //缓存
    [self cacheThemeObjectsWithSelector:@selector(setTextColor:) fristArguments:colors];
}
- (void)gt_setShadowColors:(NSArray<UIColor *> *)colors {
    if(colors.count >[GTThemeManager shareInstance].currentThemeVersion) {
        UIColor *color = [colors objectAtIndex:[GTThemeManager shareInstance].currentThemeVersion];
        [self setShadowColor:color];
    }
    //缓存
    [self cacheThemeObjectsWithSelector:@selector(setShadowColor:) fristArguments:colors];
}
- (void)gt_setAttributedTexts:(NSArray<NSAttributedString *> *)attributedTexts {
    
    if(attributedTexts.count >[GTThemeManager shareInstance].currentThemeVersion) {
        NSAttributedString *attributedString = [attributedTexts objectAtIndex:[GTThemeManager shareInstance].currentThemeVersion];
        [self setAttributedText:attributedString];
    }
    //缓存
    [self cacheThemeObjectsWithSelector:@selector(setAttributedText:) fristArguments:attributedTexts];
}
@end
