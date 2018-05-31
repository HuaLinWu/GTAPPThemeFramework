//
//  NSObjectDellocManager.h
//  GTAPPThemeFrameWork
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObjectDellocManager : NSObject
- (void)addDeallocBlock:(void(^)(void))deallocBlok;
@end
