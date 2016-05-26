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
 * DES加密字字符串，然后再进行base64编码
 * @params:
 *        strKey: 加密密钥，此密钥只能8位
 */
- (NSString *) desEncryptStr:(NSString *) strKey;

/**
 * DES解密字符串，此字符串是经过base64编码的
 * @params:
 *        strKey: 加密密钥，此密钥只能8位
 */
- (NSString *) desDecryptStr:(NSString *) strKey;

@end
