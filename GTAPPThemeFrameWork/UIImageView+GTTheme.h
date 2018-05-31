//
//  UIImageView+GTTheme.h
//  GTAPPThemeChanage
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GTTheme)
- (void)gt_setImages:(NSArray<UIImage *> *)images;
- (void)gt_setHighlightedImages:(NSArray <UIImage *> *)highlightedImages;
@end
