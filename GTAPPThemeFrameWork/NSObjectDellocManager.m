//
//  NSObjectDellocManager.m
//  GTAPPThemeFrameWork
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import "NSObjectDellocManager.h"
@interface NSObjectDellocManager()
@property(nonatomic,strong)NSMutableArray<void(^)(void)> *deallocBlocks;
@end
@implementation NSObjectDellocManager
- (void)addDeallocBlock:(void(^)(void))deallocBlok {
    if(deallocBlok) {
        [self.deallocBlocks addObject:deallocBlok];
    }
}
#pragma mark set/get
- (NSMutableArray *)deallocBlocks {
    if(!_deallocBlocks) {
        _deallocBlocks = [[NSMutableArray alloc] init];
    }
    return _deallocBlocks;
}
#pragma mark dealloc
- (void)dealloc {
    [_deallocBlocks enumerateObjectsUsingBlock:^(void (^ _Nonnull obj)(void), NSUInteger idx, BOOL * _Nonnull stop) {
        obj();
    }];
    _deallocBlocks = nil;
}

@end
