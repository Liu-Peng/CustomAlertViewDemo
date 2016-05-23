//
//  ViewController.m
//  CustomAlertViewDemo
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 LiuPeng. All rights reserved.
//

#import "ViewController.h"
#import "LPCustomAlertView.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    for (int i=0; i<4; i++) {
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.backgroundColor = [UIColor redColor];
        button1.frame = CGRectMake(100, 70 *(i+1), 80, 40);
        button1.tag = i;
        [self.view addSubview:button1];
        NSString * str = [NSString stringWithFormat:@"样式 %d",i+1];
        [button1 setTitle:str forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(doTapButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)doTapButton:(UIButton *)button {
    
    LPCustomAlertView * alert = [LPCustomAlertView alertViewWithTitle:@"测试Title" message:@"测试Message"];
    
    if (button.tag == 0) {
        [alert addAction:[LPAlertAction actionWithTitle:@"取消" style:LPAlertViewButtonStyleCancel handler:^(LPAlertAction *alertAction) {
        }]];
        [alert addAction:[LPAlertAction actionWithTitle:@"确定" style:LPAlertViewButtonStyleDefault handler:^(LPAlertAction *alertAction) {
            
        }]];
    }else if (button.tag == 1) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入测试信息";
            
        }];
        [alert addAction:[LPAlertAction actionWithTitle:@"确定" style:LPAlertViewButtonStyleDestructive handler:^(LPAlertAction *alertAction) {
            
        }]];
    }else if (button.tag == 2) {
        [alert addDotsAnimatedViewHandler:^(AMTumblrHud *dotsView) {
            dotsView.hudColor = [UIColor redColor];
        }];
        [alert addAction:[LPAlertAction actionWithTitle:@"取消" style:LPAlertViewButtonStyleCancel handler:^(LPAlertAction *alertAction) {
        }]];
        [alert addAction:[LPAlertAction actionWithTitle:@"确定" style:LPAlertViewButtonStyleDefault handler:^(LPAlertAction *alertAction) {
            
        }]];
        [alert addAction:[LPAlertAction actionWithTitle:@"不再提醒" style:LPAlertViewButtonStyleDestructive handler:^(LPAlertAction *alertAction) {
            
        }]];
    }else if (button.tag == 3) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入测试信息";
            
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入测试信息";
            
        }];
        [alert addAction:[LPAlertAction actionWithTitle:@"取消" style:LPAlertViewButtonStyleCancel handler:^(LPAlertAction *alertAction) {
        }]];
        [alert addAction:[LPAlertAction actionWithTitle:@"确定" style:LPAlertViewButtonStyleDestructive handler:^(LPAlertAction *alertAction) {
            
        }]];
    }
    
    
    [alert showAlert];
    
    //    NSLog(@"alert.alertActions = %@",alert.alertActions);
    //    NSLog(@"alert.textFields = %@",alert.textFields);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
