//
//  UIImageView+GTTheme.m
//  GTAPPThemeChanage
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import "UIImageView+GTTheme.h"
#import "NSObject+GTTheme.h"
#import "GTThemeManager.h"
@implementation UIImageView (GTTheme)
- (void)gt_setImages:(NSArray<UIImage *> *)images {
    if(images.count >[GTThemeManager shareInstance].currentThemeVersion) {
        UIImage *image = images[[GTThemeManager shareInstance].currentThemeVersion];
        [self setImage:image];
    }
    //缓存
    [self cacheThemeObjectsWithSelector:@selector(setImage:) fristArguments:images];
}
- (void)gt_setHighlightedImages:(NSArray <UIImage *> *)highlightedImages {
    
    if(highlightedImages.count >[GTThemeManager shareInstance].currentThemeVersion) {
        UIImage *image = highlightedImages[[GTThemeManager shareInstance].currentThemeVersion];
        [self setHighlightedImage:image];
    }
    //缓存
    [self cacheThemeObjectsWithSelector:@selector(setHighlightedImage:) fristArguments:highlightedImages];
}

@end
