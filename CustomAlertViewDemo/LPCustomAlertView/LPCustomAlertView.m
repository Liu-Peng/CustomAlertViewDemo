//
//  LPCustomAlertView.m
//  CustomAlertViewDemo
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 LiuPeng. All rights reserved.
//

#import "LPCustomAlertView.h"
#import "Masonry.h"


//屏幕宽高
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000

    #define LP_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
    boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) \
    attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

#else

    #define LP_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
    sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;

#endif



//返回名字为weakSelf的弱引用self对象
#define WEAKSELF typeof(self) __weak weakSelf = self;

#define LPAdaptiveRate(x) ((float) x * SCREEN_WIDTH / 375.0)

#define kLPRGB(r,g,b) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0]
#define kLPColorWithString(colorString) [LPAlertAction lp_colorWithString:colorString]

#define kLPCustomTextColor kLPColorWithString(@"#ff8500")

#define kLPTitleColor kLPColorWithString(@"#000000")
#define kLPMessageColor kLPColorWithString(@"#000000")
#define kLPCancleButtonTitleColor kLPColorWithString(@"#999999")
#define kLPDelfaultButtonTitleColor kLPColorWithString(@"#ff8500")
#define kLPDestructiveButtonTitleColor [UIColor redColor]
#define kLPClearColor [UIColor clearColor]//clearColor
#define kLPLineColor kLPColorWithString(@"#f4f4f4")


#define kLPTitleFont [UIFont systemFontOfSize:LPAdaptiveRate(19)]
#define kLPMessageFont [UIFont systemFontOfSize:LPAdaptiveRate(17)]
#define kLPButtonTitleFont [UIFont systemFontOfSize:LPAdaptiveRate(19)]
#define kLPTextFieldFont [UIFont systemFontOfSize:LPAdaptiveRate(17)]

@interface LPAlertAction ()


@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) LPAlertViewButtonStyle style;
@property (nonatomic, strong) LPAlertActionHandler actionHandle;

@end

@implementation LPAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(LPAlertViewButtonStyle)style handler:(LPAlertActionHandler)handler {
   LPAlertAction * action = [[LPAlertAction alloc] init];
    if (action) {
        action.title = title;
        action.style = style;
        action.actionHandle = handler;
    }
    return action;
}

#pragma mark --色值转换
+ (UIColor *)lp_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alphaValue];
}
+ (UIColor *)lp_colorWithString:(NSString *)string {
    
    NSString *cString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor blackColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor blackColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
  
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return kLPRGB(r, g, b);

}
@end

@interface LPCustomAlertView ()
@property (nonatomic,strong) NSArray * textFields;
@property (nonatomic,strong) NSArray * alertActions;

@end

@implementation LPCustomAlertView
{
    UIView * _alertView;
    UILabel * _titleLabel;
    UILabel * _messageLabel;
    UIButton * _lastButton;
    
    NSMutableArray * _actionArray;
    NSMutableArray * _textFieldArray;
    AMTumblrHud * _dotsAnimated;
    
    UIView * _overView;//过度View
}

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message {
    
    LPCustomAlertView * alertView = [[LPCustomAlertView alloc] initWithTitle:title message:message];
    if (alertView) {
        
    }
    return alertView;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = kLPClearColor;
        
        UIView * backView = [UIView new];
        backView.frame = self.frame;
        backView.backgroundColor =kLPColorWithString(@"#000000");
        backView.alpha = 0.3;
        [self addSubview:backView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapBackView)];
        [backView addGestureRecognizer:tap];
        
        _actionArray = [NSMutableArray arrayWithCapacity:0];
        _textFieldArray = [NSMutableArray arrayWithCapacity:0];

        _alertView = [self alertView];
        _titleLabel = [self titleLabel:title];
        _messageLabel = [self messageLabel:message];
        
        [self addSubview:_alertView];
        [self addSubview:_titleLabel];
        [self addSubview:_messageLabel];

    }
    return self;
}

- (void)addAction:(LPAlertAction *)action {
    if (action) {
        [_actionArray addObject:action];
    }
}

- (void)addDotsAnimatedViewHandler:(LPAlertDotsAnimatedViewHandler)hander {
    
    AMTumblrHud *tumblrHUD = [[AMTumblrHud alloc] initWithFrame:CGRectMake(0, 0, 55, 20)];
    tumblrHUD.hudColor = [LPAlertAction lp_colorWithHex:0xF1F2F3 alpha:1];
    [_alertView addSubview:tumblrHUD];

    _dotsAnimated = tumblrHUD;
    
    if (hander) {
        hander(_dotsAnimated);
    }

}

- (void)addTextFieldWithConfigurationHandler:(LPAlertTextFieldHandler)hander {
    
    UITextField * textfield = [[UITextField alloc] init];
    textfield.backgroundColor = kLPClearColor;
    textfield.font = kLPTextFieldFont;
    if (hander) {
        hander(textfield);
    }
    [textfield addTarget:self action:@selector(textFieldsValueDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [textfield addTarget:self action:@selector(textFieldsValueDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [textfield addTarget:self action:@selector(textFieldsValueDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];

    [_alertView addSubview:textfield];
    [_textFieldArray addObject:textfield];
    
}

- (void)addButtonWithTitle:(NSString *)title type:(LPAlertViewButtonStyle)type handler:(LPAlertActionHandler)hander {
    
}
#pragma mark -- 显示
- (void)showAlert {
    
    if (_dotsAnimated) {
        [_dotsAnimated showAnimated:YES];

    }

    [self makeSubViewConstraints];
    
    if(_textFieldArray.count > 0) {
        [self makeSubViewTextFieldConstraints];
        
        UITextField * text = [_textFieldArray objectAtIndex:0];
        [text becomeFirstResponder];
    }
    
    if(_actionArray.count > 0){
        [self addButtons];
    }
    
    [self updateSubViewConstraints];

    [[[UIApplication sharedApplication].delegate window] addSubview:self];

}

- (void)dismissAlert {
    if (_textFieldArray.count > 0) {
        [self doTapBackView];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [_alertView setAlpha:0];
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark -- 事件
- (void)buttonPressed:(UIButton *)button {

    LPAlertAction *item = [_actionArray objectAtIndex:button.tag];
    if (item.actionHandle) {
        item.actionHandle(item);
    }
    [self dismissAlert];
}

- (void)doTapBackView {
    if(_textFieldArray.count > 0) {
        for (UITextField * textf in _textFieldArray) {
            [textf resignFirstResponder];
        }
    }
}

#pragma mark --SETER GETER
- (NSArray<LPAlertAction *> *)alertActions {
    return _actionArray;
}
- (NSArray<UITextField *> *)textFields {
    return _textFieldArray;
}

#pragma mark --subViews

- (UIView *)alertView {
    UIView * alert = [UIView new];
    alert.backgroundColor = kLPColorWithString(@"#ffffff");
    alert.layer.cornerRadius = 5;
//    alert.alpha = 1;
    
    return alert;
}
- (UILabel *)titleLabel:(NSString *)title {
    if (title) {
        UILabel * titlelbl = [UILabel new];
        titlelbl.text = title;
        titlelbl.backgroundColor = kLPClearColor;
        titlelbl.textColor = kLPTitleColor;
        titlelbl.font = kLPTitleFont;
        titlelbl.numberOfLines  = 0;
        titlelbl.textAlignment = NSTextAlignmentCenter;
        CGSize titlesize = LP_MULTILINE_TEXTSIZE(title, kLPTitleFont, CGSizeMake(LPAdaptiveRate(225), 200), NSLineBreakByWordWrapping);
        titlelbl.frame = CGRectMake(0, 0, titlesize.width, titlesize.height);

        return titlelbl;
    }
    return nil;
}

- (UILabel *)messageLabel:(NSString *)message {
    if (message) {
        UILabel * messagelbl = [UILabel new];
        messagelbl.text = message;
        messagelbl.backgroundColor = kLPClearColor;
        messagelbl.textColor = kLPMessageColor;
        messagelbl.font = kLPMessageFont;
        messagelbl.numberOfLines  = 0;
        messagelbl.textAlignment = NSTextAlignmentCenter;
        CGSize messagesize = LP_MULTILINE_TEXTSIZE(message, kLPMessageFont, CGSizeMake(LPAdaptiveRate(225), 200), NSLineBreakByWordWrapping);
        messagelbl.frame = CGRectMake(0, 0, messagesize.width, messagesize.height);
        
        return messagelbl;
    }
    return nil;
}

- (void)addButtons {

    UIView *_lineBtn = [[UIView alloc] init];
    [_lineBtn setBackgroundColor:kLPLineColor];
    [_alertView addSubview:_lineBtn];
    
    [_lineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_alertView).offset(0);
        if (_overView) {
            make.top.equalTo(_overView.mas_bottom).offset(LPAdaptiveRate(15));
        }else{
            make.top.equalTo(_alertView).offset(LPAdaptiveRate(15));
        }
        make.height.mas_equalTo(LPAdaptiveRate(1));
    }];

    
    for (int i = 0 ; i < _actionArray.count; i ++) {
        
        LPAlertAction *item = [_actionArray objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setTitle:item.title forState:UIControlStateHighlighted];
        if(item.style == LPAlertViewButtonStyleCancel) {
            [btn setTitleColor:kLPCancleButtonTitleColor forState:UIControlStateNormal];
            [btn setTitleColor:kLPCancleButtonTitleColor forState:UIControlStateHighlighted];
        }else if(item.style == LPAlertViewButtonStyleDefault){
            [btn setTitleColor:kLPDelfaultButtonTitleColor forState:UIControlStateNormal];
            [btn setTitleColor:kLPDelfaultButtonTitleColor forState:UIControlStateHighlighted];
        }else if (item.style == LPAlertViewButtonStyleDestructive){
            [btn setTitleColor:kLPDestructiveButtonTitleColor forState:UIControlStateNormal];
            [btn setTitleColor:kLPDestructiveButtonTitleColor forState:UIControlStateHighlighted];
        }
        [btn.titleLabel setFont:kLPButtonTitleFont];
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = kLPClearColor;

        [_alertView addSubview:btn];
        
        
        if (_actionArray.count == 1) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(_lineBtn);
                make.top.equalTo(_lineBtn.mas_bottom).offset(LPAdaptiveRate(15));
                make.height.mas_equalTo(LPAdaptiveRate(19));
                make.bottom.equalTo(_alertView).offset(LPAdaptiveRate(-15));

            }];
        }else if (_actionArray.count == 2) {
            
            UIView *line = [[UIView alloc] init];
            [line setBackgroundColor:kLPLineColor];
            [_alertView addSubview:line];
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_lineBtn.mas_bottom).offset(0);
                make.height.mas_equalTo(LPAdaptiveRate(44));
                make.width.mas_equalTo(LPAdaptiveRate(1));
                make.left.equalTo(_lineBtn.mas_centerX);
            }];
            
            if (i == 0) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_lineBtn);
                    make.top.equalTo(_lineBtn.mas_bottom).offset(LPAdaptiveRate(15));
                    make.height.mas_equalTo(LPAdaptiveRate(19));
                    make.right.equalTo(_lineBtn.mas_centerX);
                }];
            }else{
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(line);
                    make.right.mas_equalTo(LPAdaptiveRate(0));
                    make.top.equalTo(_lineBtn.mas_bottom).offset(LPAdaptiveRate(15));
                    make.height.mas_equalTo(LPAdaptiveRate(19));
                    make.bottom.equalTo(_alertView).offset(LPAdaptiveRate(-15));
                }];
            }
        }else {

            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(_lineBtn);
                if (_lastButton) {
                    make.top.equalTo(_lastButton.mas_bottom).offset(LPAdaptiveRate(21));
                    
                }else{
                    make.top.equalTo(_lineBtn.mas_bottom).offset(LPAdaptiveRate(10));
                }
                make.height.mas_equalTo(LPAdaptiveRate(19));
                if (i == _actionArray.count - 1) {
                    make.bottom.equalTo(_alertView).offset(LPAdaptiveRate(-15));
                }
            }];
            
            _lastButton = btn;
            if (i < _actionArray.count - 1) {
                UIView *_lBtn = [[UIView alloc] init];
                [_lBtn setBackgroundColor:kLPLineColor];
                [_alertView addSubview:_lBtn];
                
                [_lBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.equalTo(_alertView).offset(0);
                    make.top.equalTo(_lastButton.mas_bottom).offset(LPAdaptiveRate(10));
                    make.height.mas_equalTo(LPAdaptiveRate(1));
                }];
            }

        }
        
    }
}

#pragma mark --UITextFieldDelegate 及 监听方法
- (void)textFieldsValueDidBegin:(UITextField *)textField {
    //NSLog(@"开始  _alertView = %@",_alertView);
    WEAKSELF;
    [UIView animateWithDuration:0.4
                     animations:^{
                         [_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
                             make.centerY.equalTo(weakSelf).offset(LPAdaptiveRate(-90));
                         }];
                    } completion:^(BOOL finished) {
               }];


}

- (void)textFieldsValueDidEnd:(UITextField *)textField {
    //NSLog(@"结束");
    WEAKSELF;
    [UIView animateWithDuration:0.4
                     animations:^{
                         [_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
                             make.centerY.equalTo(weakSelf).offset(LPAdaptiveRate(-20));
                         }];
                     } completion:^(BOOL finished) {
                     }];
}

- (void)textFieldsValueDidEndOnExit:(UITextField *)textField {

    for (NSInteger i = 0; i<_textFieldArray.count; i++) {
        UITextField * text = [_textFieldArray objectAtIndex:i];
        if ([text isEqual:textField] && (i <= (_textFieldArray.count - 2.0))) {
            //NSLog(@"i = %ld",i);
            UITextField * textnext = [_textFieldArray objectAtIndex:i+1];
            [textnext becomeFirstResponder];
        }
    }
    
}

#pragma mark --update subviews
- (void)makeSubViewConstraints {
    WEAKSELF;
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LPAdaptiveRate(60));
        make.right.mas_equalTo(LPAdaptiveRate(-60));
        make.centerY.equalTo(weakSelf).offset(LPAdaptiveRate(-20));
//        make.top.mas_equalTo(LPAdaptiveRate(242)).priorityLow();
//        make.height.mas_equalTo(LPAdaptiveRate(184)).priorityLow();
        
    }];
    
    if (_dotsAnimated) {
        [_dotsAnimated mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerX.equalTo(_alertView).offset(-27.5);
            if (_overView) {
                make.top.equalTo(_overView.mas_bottom).offset(LPAdaptiveRate(15));
            }else {
                make.top.equalTo(_alertView).offset(LPAdaptiveRate(17));
            }
        }];
        _overView = _dotsAnimated;
    }
    
    if(_titleLabel){
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_alertView).offset(LPAdaptiveRate(15));
            make.right.equalTo(_alertView).offset(LPAdaptiveRate(-15));
            if (_overView) {
                make.top.equalTo(_overView.mas_bottom).offset(LPAdaptiveRate(15+12));
            }else {
                make.top.equalTo(_alertView).offset(LPAdaptiveRate(15));
            }
            
            make.bottom.equalTo(_alertView).offset(LPAdaptiveRate(-15)).priority(249);

        }];
        _overView = _titleLabel;
    }
    if (_messageLabel) {
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_alertView).offset(LPAdaptiveRate(15));
            make.right.equalTo(_alertView).offset(LPAdaptiveRate(-15));
            if (_overView) {
                make.top.equalTo(_overView.mas_bottom).offset(LPAdaptiveRate(15));
            }else {
                make.top.equalTo(_alertView).offset(LPAdaptiveRate(15));
            }
            make.bottom.equalTo(_alertView).offset(LPAdaptiveRate(-15)).priorityLow();
        }];
        _overView = _messageLabel;
    }

}

- (void)makeSubViewTextFieldConstraints {
    for (UITextField * textfield in _textFieldArray) {
        UIView *_lineV = [[UIView alloc] init];
        [_lineV setBackgroundColor:kLPLineColor];
        [_alertView addSubview:_lineV];
        
        [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_alertView);
            if (_overView) {
                make.top.equalTo(_overView.mas_bottom).offset(LPAdaptiveRate(15));
            }else {
                make.top.equalTo(_alertView).offset(LPAdaptiveRate(15));
            }
            make.height.mas_equalTo(LPAdaptiveRate(1));
        }];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_alertView).offset(LPAdaptiveRate(30));
            make.right.equalTo(_alertView).offset(LPAdaptiveRate(-30));
            make.top.equalTo(_lineV.mas_bottom).offset(LPAdaptiveRate(15));
            make.height.mas_equalTo(LPAdaptiveRate(17));
        }];
        _overView = textfield;
    }
    
}

- (void)updateSubViewConstraints {

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
