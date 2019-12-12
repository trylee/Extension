//
//  UIColor+LGCategory.h
//  Category
//
//  Created by 李国 on 2019/12/12.
//  Copyright © 2019 央戈科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (LGCategory)

/**
 通过RGB值设置颜色（不需要/255.0）
 
 @param red 传入red值
 @param green 传入green值
 @param blue 传入blue值
 @return 返回颜色
 */
+ (UIColor *) colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue;


/**
 通过RGB值设置颜色（不需要/255.0）
 
 @param red 传入red值
 @param green 传入green值
 @param blue 传入blue值
 @param alpha 传入透明度
 @return 返回颜色
 */
+ (UIColor *) colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue Alpha:(CGFloat)alpha;


/**
 通过Hex设置颜色(支持0x开头、#开头，也可是6位的16进制字符串)
 
 @param hex 传入16进制颜色字符串
 @return 返回颜色
 */
+ (UIColor *)colorWithHex:(NSString *)hex;


/**
 通过Hex设置颜色(支持0x开头、#开头，也可是6位的16进制字符串)
 
 @param hex 传入16进制颜色字符串
 @param alpha 传入透明度
 @return 返回颜色
 */
+ (UIColor *)colorWithHex:(NSString *)hex Alpha:(CGFloat)alpha;


@end

