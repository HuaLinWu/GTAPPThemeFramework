//
//  GTThemeManager.h
//  GTAPPThemeChanage
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTThemeDefine.h"
@interface GTThemeManager : NSObject
@property(nonatomic,assign)GTThemeVersion currentThemeVersion;
+ (instancetype)shareInstance;
@end
