//
//  UIColor+LGCategory.m
//  Category
//
//  Created by 李国 on 2019/12/12.
//  Copyright © 2019 央戈科技. All rights reserved.
//

#import "UIColor+LGCategory.h"

@implementation UIColor (LGCategory)


/**
 通过RGB值设置颜色（不需要/255.0）
 
 @param red 传入red值
 @param green 传入green值
 @param blue 传入blue值
 @return 返回颜色
 */
+ (UIColor *) colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue
{
    return [self colorWithR:red G:green B:blue Alpha:1.0];
}


/**
 通过RGB值设置颜色（不需要/255.0）
 
 @param red 传入red值
 @param green 传入green值
 @param blue 传入blue值
 @param alpha 传入透明度
 @return 返回颜色
 */
+ (UIColor *) colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue Alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}


/**
 通过Hex设置颜色(支持0x开头、#开头，也可是6位的16进制字符串)
 
 @param hex 传入16进制颜色字符串
 @return 返回颜色
 */
+ (UIColor *)colorWithHex:(NSString *)hex
{
    return [self colorWithHex:hex Alpha:1.0f];
}


/**
 通过Hex设置颜色(支持0x开头、#开头，也可是6位的16进制字符串)
 
 @param hex 传入16进制颜色字符串
 @param alpha 传入透明度
 @return 返回颜色
 */
+ (UIColor *)colorWithHex:(NSString *)hex Alpha:(CGFloat)alpha;
{
    // 判断参数格式是否正确
    NSString * cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) return [UIColor blackColor];
    
    // 截取颜色字符串
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // 依次截取RGB对应字符串
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    
    // 色值转换
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:rString] scanHexInt:&red];
    [[NSScanner scannerWithString:gString] scanHexInt:&green];
    [[NSScanner scannerWithString:bString] scanHexInt:&blue];
    
    return [self colorWithR:red G:green B:blue Alpha:alpha];
}


@end
