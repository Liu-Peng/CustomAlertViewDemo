# CustomAlertViewDemo
![image](https://github.com/Liu-Peng/CustomAlertViewDemo/blob/master/Image/IMG_0075.PNG)
![image](https://github.com/Liu-Peng/CustomAlertViewDemo/blob/master/Image/IMG_0076.PNG)
![image](https://github.com/Liu-Peng/CustomAlertViewDemo/blob/master/Image/IMG_0077.PNG)
![image](https://github.com/Liu-Peng/CustomAlertViewDemo/blob/master/Image/IMG_0078.PNG)
# Installation
Add the LPCustomAlertView.h and LPCustomAlertView.m source files to your project.

Download the latest code version or add the repository as a git submodule to your git-tracked project.
Open your project in Xcode, then drag and drop LPCustomAlertView.h and LPCustomAlertView.m onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.
Include LPCustomAlertView wherever you need it with #import "LPCustomAlertView.h"

# Usage
    LPCustomAlertView * alert = [LPCustomAlertView alertViewWithTitle:@"测试Title" message:@"测试Message"];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入测试信息";
    }];
    [alert addAction:[LPAlertAction actionWithTitle:@"取消" style:LPAlertViewButtonStyleCancel handler:^(LPAlertAction *alertAction) {
    }]];
    [alert addAction:[LPAlertAction actionWithTitle:@"确定" style:LPAlertViewButtonStyleDefault handler:^(LPAlertAction *alertAction) {
    }]];
    [alert showAlert];

# License
This code is distributed under the terms and conditions of the MIT license.




