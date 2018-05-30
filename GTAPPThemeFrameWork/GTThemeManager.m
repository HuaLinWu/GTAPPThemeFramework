//
//  GTThemeManager.m
//  GTAPPThemeChanage
//
//  Created by 吴华林 on 2018/5/28.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import "GTThemeManager.h"

@implementation GTThemeManager
static GTThemeManager *manager;
+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GTThemeManager alloc] init];
    });
    return manager;
}
#pragma mark set/get
- (void)setCurrentThemeVersion:(GTThemeVersion)currentThemeVersion {
    if(_currentThemeVersion != currentThemeVersion) {
        _currentThemeVersion = currentThemeVersion;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:currentThemeVersion] forKey:@"GTThemeVersion"];
        [[NSNotificationCenter defaultCenter] postNotificationName:GTThemeChanageNotification object:nil];
        
    }
}
@end
