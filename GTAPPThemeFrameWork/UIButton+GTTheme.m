//
//  UIButton+GTTheme.m
//  GTAPPThemeChanage
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import "UIButton+GTTheme.h"
#import "GTThemeManager.h"
#import "NSObject+GTTheme.h"
@implementation UIButton (GTTheme)
- (void)gt_setTitleColors:(NSArray<UIColor *> *)colors forState:(UIControlState)state {
    if(colors.count >[GTThemeManager shareInstance].currentThemeVersion) {
        UIColor *color = [colors objectAtIndex:[GTThemeManager shareInstance].currentThemeVersion];
        [self setTitleColor:color forState:state];
    }
    //缓存
    NSMutableArray *aySecondArgument = [[NSMutableArray alloc] init];
    for(int i=0;i<colors.count;i++) {
        [aySecondArgument addObject:[NSNumber numberWithInteger:state]];
    }
    [self cacheThemeObjectsWithSelector:@selector(setTitleColor:forState:) fristArguments:colors secondArguments:aySecondArgument];
}
- (void)gt_setTitleShadowColors:(NSArray<UIColor *> *)colors forState:(UIControlState)state {
    if(colors.count >[GTThemeManager shareInstance].currentThemeVersion) {
        UIColor *color = [colors objectAtIndex:[GTThemeManager shareInstance].currentThemeVersion];
        [self setTitleShadowColor:color forState:state];
    }
    //缓存
    NSMutableArray *aySecondArgument = [[NSMutableArray alloc] init];
    for(int i=0;i<colors.count;i++) {
        [aySecondArgument addObject:[NSNumber numberWithInteger:state]];
    }
    [self cacheThemeObjectsWithSelector:@selector(setTitleShadowColor:forState:) fristArguments:colors secondArguments:aySecondArgument];
}
- (void)gt_setImages:(NSArray<UIImage *> *)images forState:(UIControlState)state {
    if(images.count >[GTThemeManager shareInstance].currentThemeVersion) {
        UIImage *image = images[[GTThemeManager shareInstance].currentThemeVersion];
        [self setImage:image forState:state];
    }
    //缓存
    NSMutableArray *aySecondArgument = [[NSMutableArray alloc] init];
    for(int i=0;i<images.count;i++) {
        [aySecondArgument addObject:[NSNumber numberWithInteger:state]];
    }
    [self cacheThemeObjectsWithSelector:@selector(setImage:forState:) fristArguments:images secondArguments:aySecondArgument];
    
}
- (void)gt_setBackgroundImages:(NSArray<UIImage *> *)images forState:(UIControlState)state {
    
    if(images.count >[GTThemeManager shareInstance].currentThemeVersion) {
        UIImage *image = images[[GTThemeManager shareInstance].currentThemeVersion];
        [self setBackgroundImage:image forState:state];
    }
    //缓存
    NSMutableArray *aySecondArgument = [[NSMutableArray alloc] init];
    for(int i=0;i<images.count;i++) {
        [aySecondArgument addObject:[NSNumber numberWithInteger:state]];
    }
    [self cacheThemeObjectsWithSelector:@selector(setBackgroundImage:forState:) fristArguments:images secondArguments:aySecondArgument];
}
- (void)gt_setAttributedTitles:(NSArray<NSAttributedString *> *)attributedTitles forState:(UIControlState)state {
    
    if(attributedTitles.count >[GTThemeManager shareInstance].currentThemeVersion) {
        NSAttributedString *attributedString = attributedTitles[[GTThemeManager shareInstance].currentThemeVersion];
        [self setAttributedTitle:attributedString forState:state];
    }
    //缓存
    NSMutableArray *aySecondArgument = [[NSMutableArray alloc] init];
    for(int i=0;i<attributedTitles.count;i++) {
        [aySecondArgument addObject:[NSNumber numberWithInteger:state]];
    }
    [self cacheThemeObjectsWithSelector:@selector(setAttributedTitle:forState:) fristArguments:attributedTitles secondArguments:aySecondArgument];
}
@end
