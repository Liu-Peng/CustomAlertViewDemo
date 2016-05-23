//
//  LPCustomAlertView.h
//  CustomAlertViewDemo
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 LiuPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMTumblrHud.h"

typedef NS_ENUM(NSInteger, LPAlertViewButtonStyle) {
    LPAlertViewButtonStyleDefault = 0,//默认主色
    LPAlertViewButtonStyleCancel,//灰色
    LPAlertViewButtonStyleDestructive  //红色
};

@class LPAlertAction;

typedef void(^LPAlertActionHandler)(LPAlertAction * alertAction);

typedef void(^LPAlertTextFieldHandler)(UITextField * textField);

typedef void(^LPAlertDotsAnimatedViewHandler)(AMTumblrHud * dotsView);


@interface LPAlertAction : NSObject

+ (instancetype)actionWithTitle:( NSString *)title style:(LPAlertViewButtonStyle)style handler:(LPAlertActionHandler)handler;

@end


@interface LPCustomAlertView : UIView

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message;

- (void)addAction:(LPAlertAction *)action;
- (void)addDotsAnimatedViewHandler:(LPAlertDotsAnimatedViewHandler)hander;
- (void)addTextFieldWithConfigurationHandler:(LPAlertTextFieldHandler)hander;

- (void)addButtonWithTitle:( NSString *)title type:(LPAlertViewButtonStyle)type handler:(LPAlertActionHandler)hander;


@property (nonatomic, readonly) NSArray<UITextField *> *textFields;
@property (nonatomic, readonly) NSArray<LPAlertAction *> *alertActions;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

-(void)showAlert;
-(void)dismissAlert;

@end
