//
//  GTThemeInvocationObject.h
//  GTThemeFramework
//
//  Created by 吴华林 on 2018/6/5.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTThemeInvocationObject : NSObject
@property (readonly,nonatomic, strong) NSMethodSignature *methodSignature;
- (instancetype)initWithTarget:(id)target selector:(SEL)selector;
- (void)setArgument:(id)argumentLocation atIndex:(NSInteger)idx;
- (void)invoke;
@end
