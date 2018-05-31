//
//  UILabel+GTTheme.h
//  GTAPPThemeFrameWork
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (GTTheme)
- (void)gt_setTextColors:(NSArray<UIColor *> *)colors;
- (void)gt_setShadowColors:(NSArray<UIColor *> *)colors;
- (void)gt_setAttributedTexts:(NSArray<NSAttributedString *> *)attributedTexts;
@end
