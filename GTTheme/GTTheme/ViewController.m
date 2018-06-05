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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btnDay;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *btnNight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.btnDay.selected = YES;
    [self.btnDay gt_setThemeObjectsAndInvokeWithSeletor:@selector(setTitleColor:forState:) params:@[[UIColor blackColor],[UIColor whiteColor]],@(UIControlStateSelected), nil];
//    [self gt_setThemeObjectsAndInvokeWithSeletor:@selector(setBgViewColor:btnDayTitleColor:labelTextColor:textField:) params:@[[UIColor whiteColor],[UIColor blackColor]],@[[UIColor blackColor],[UIColor whiteColor]],@[[UIColor blackColor],[UIColor whiteColor]],@[[UIColor blackColor],[UIColor whiteColor]], nil];
    
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

- (void)setBgViewColor:(UIColor *)bgColor btnDayTitleColor:(UIColor *)dayTitleColor  labelTextColor:(UIColor *)labelTextColor textField:(UIColor *)textColor {
    self.view.backgroundColor = bgColor;
    [self.btnDay setTitleColor:dayTitleColor forState:UIControlStateNormal];
    [self.label setTextColor:labelTextColor];
    [self.textView setTextColor:textColor];
}
@end
