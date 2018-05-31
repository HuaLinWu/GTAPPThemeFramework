//
//  UIButton+GTTheme.h
//  GTAPPThemeChanage
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (GTTheme)
- (void)gt_setTitleColors:(NSArray<UIColor *> *)colors forState:(UIControlState)state;
- (void)gt_setTitleShadowColors:(NSArray<UIColor *> *)colors forState:(UIControlState)state;
- (void)gt_setImages:(NSArray<UIImage *> *)images forState:(UIControlState)state;
- (void)gt_setBackgroundImages:(NSArray<UIImage *> *)images forState:(UIControlState)state;
- (void)gt_setAttributedTitles:(NSArray<NSAttributedString *> *)attributedTitles forState:(UIControlState)state;
@end
