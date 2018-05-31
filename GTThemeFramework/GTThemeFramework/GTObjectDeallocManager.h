//
//  GTObjectDeallocManager.h
//  GTThemeFramework
//
//  Created by 吴华林 on 2018/5/29.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTObjectDeallocManager : NSObject
- (void)addDeallocBlock:(void(^)(void))block;
@end
