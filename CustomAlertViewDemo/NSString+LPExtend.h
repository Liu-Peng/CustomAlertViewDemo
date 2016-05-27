//
//  NSString+LPExtend.h
//  CustomAlertViewDemo
//
//  Created by admin on 16/5/26.
//  Copyright © 2016年 LiuPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LPExtend)
/**
 *  MD5 加密
 *
 *  @return NSString
 */
- (NSString *) lp_stringFromMD5;


+ (UIColor *)lp_colorWithHex:(NSInteger)hexValue;

+ (UIColor *)lp_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor *)lp_colorWithString:(NSString *)string;
@end
