//
//  GTThemeManager.m
//  GTThemeFramework
//
//  Created by 吴华林 on 2018/5/29.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import "GTThemeManager.h"

@implementation GTThemeManager
+(instancetype)shareInstance {
    static GTThemeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GTThemeManager alloc] init];
    });
    return manager;
}
#pragma mark set/get
- (void)setCurrentThemeVersion:(GTThemeVersion)themeVersion {
    if(_currentThemeVersion !=themeVersion) {
        _currentThemeVersion = themeVersion;
        [[NSNotificationCenter defaultCenter] postNotificationName:GTThemeVersionChangeNotification object:nil];
    }
}
@end
