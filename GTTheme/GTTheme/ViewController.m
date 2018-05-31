//
//  ViewController.m
//  GTTheme
//
//  Created by 吴华林 on 2018/5/29.
//  Copyright © 2018年 吴华林. All rights reserved.
//

#import "ViewController.h"
#import <GTThemeFramework/GTThemeFramework.h>
#import <objc/runtime.h>
#define GSKeyPath(OBJ, PATH) \
@(((void)(NO && ((void)[OBJ PATH], NO)), #PATH))

#define GTMethodInvoke(OBJ,SEL,args)  \
{\
NSString *str = GSKeyPath(OBJ,SEL);\
 NSMutableArray *array =[NSMutableArray arrayWithArray:[str componentsSeparatedByString:@":"]];\
for(int i=0;i<array.count;i++) {\
    if(i%2==1) {\
        [array replaceObjectAtIndex:i withObject:@""];\
    }\
}\
 NSString *strMethod=[array componentsJoinedByString:@":"];\
 SEL seletor = NSSelectorFromString(strMethod);\
 [OBJ cacheThemeObjectsWithSeletor:seletor fristParams:args];\
}

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
    NSArray *ayColors = @[[UIColor whiteColor],[UIColor blackColor]];
//    GTMethodInvoke(self.view, setBackgroundColor:nil, ayColors);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dayButtonAction:(UIButton *)sender {
    [GTThemeManager shareInstance].currentThemeVersion = GTDayVersion;
}
- (IBAction)nightButtonAction:(UIButton *)sender {
    [GTThemeManager shareInstance].currentThemeVersion = GTNightVersion;
}


@end
