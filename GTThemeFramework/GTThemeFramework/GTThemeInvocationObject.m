//
//  GTThemeInvocationObject.m
//  GTThemeFramework
//
//  Created by 吴华林 on 2018/6/5.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import "GTThemeInvocationObject.h"
@interface GTThemeInvocationObject()
@property(nonatomic,assign)id target;
@property SEL selector;
@property (nonatomic, strong) NSMethodSignature *methodSignature;
@property(nonatomic,strong)NSInvocation *invocation;
@property(nonatomic,strong)NSMutableArray *ayArgument;
@end
@implementation GTThemeInvocationObject
- (instancetype)initWithTarget:(id)target selector:(SEL)selector {
    self = [super init];
    if(self) {
        _methodSignature =[target methodSignatureForSelector:selector];
        _target = target;
        _selector = selector;
        _ayArgument = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)setArgument:(id)argumentLocation atIndex:(NSInteger)idx {
   
    if(self.ayArgument.count >(idx-2)) {
        [self.ayArgument replaceObjectAtIndex:idx-2 withObject:argumentLocation];
    } else {
        [self.ayArgument insertObject:argumentLocation atIndex:idx-2];
    }
    [self.invocation setArgument:&argumentLocation atIndex:idx];
}
- (void)invoke {
    for(int i =0;i<self.ayArgument.count;i++) {
        id argumentLocation = self.ayArgument[i];
        if(strcmp([self.methodSignature getArgumentTypeAtIndex:i], "Q") ==0) {
            NSUInteger argument = [argumentLocation unsignedIntegerValue];
             [_invocation setArgument:&argument atIndex:i+2];
        } else {
           [_invocation setArgument:&argumentLocation atIndex:i+2];
        }
       
    }
    [_invocation invoke];
}
#pragma mark set/get
- (NSInvocation *)invocation {
    if(!_invocation) {
        _invocation = [NSInvocation invocationWithMethodSignature:_methodSignature];
        _invocation.target = _target;
        _invocation.selector = _selector;
    }
    return _invocation;
}
@end
