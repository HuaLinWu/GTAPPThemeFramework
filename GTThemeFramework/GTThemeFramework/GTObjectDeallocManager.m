//
//  GTObjectDeallocManager.m
//  GTThemeFramework
//
//  Created by 吴华林 on 2018/5/29.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import "GTObjectDeallocManager.h"
@interface GTObjectDeallocManager()
@property(nonatomic,strong)NSMutableArray<void(^)(void)> *ayBlock;
@end
@implementation GTObjectDeallocManager
- (void)addDeallocBlock:(void(^)(void))block {
    if(block) {
        [self.ayBlock addObject:[block copy]];
    }
}
#pragma mark set/get
- (NSMutableArray *)ayBlock {
    if(!_ayBlock) {
        _ayBlock = [[NSMutableArray alloc] init];
    }
    return _ayBlock;
}
#pragma dealloc
- (void)dealloc {
    [_ayBlock enumerateObjectsUsingBlock:^(void (^ _Nonnull obj)(void), NSUInteger idx, BOOL * _Nonnull stop) {
        obj();
    }];
    [_ayBlock removeAllObjects];
    _ayBlock = nil;
}
@end
