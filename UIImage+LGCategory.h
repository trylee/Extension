//
//  UIImage+LGCategory.h
//  Category
//
//  Created by 李国 on 2019/12/12.
//  Copyright © 2019 央戈科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LGCategory)

/**
 由颜色生成图片
 
 @param color 传入颜色
 @return 返回完成图片
 */
+ (UIImage *) imageWithColor:(UIColor*)color;


/**
 生成动态图片
 
 @param gifData 传入gif图片的二进制数据
 @return 返回动态图片
 */
+(UIImage *) imageWithGifData:(NSData *)gifData;


/**
 创建水印图片
 
 @param waterMark 传入水印文字
 @param size 传入图片大小
 @return 返回水印图片
 */
+(UIImage *) imageWithWaterMark:(NSString *)waterMark size:(CGSize)size;


/**
 图片缩放至某尺寸
 
 @param size 传入缩放尺寸
 @return 返回完成图片
 */
- (UIImage *) zoomToSize:(CGSize)size;


/**
 图片缩放至某比例
 
 @param scale 传入缩放比例
 @return 返回完成图片
 */
- (UIImage *) zoomToScale:(CGFloat)scale;


/**
 裁剪图片某个区域
 
 @param rect 传入裁剪区域
 @return 返回完成图片
 */
- (UIImage *) clipWithRect:(CGRect)rect;


/**
 图片拉伸保护区域（多用于聊天框拉伸）
 
 @param insets 设置不被拉伸区域
 @return 返回完成图片
 */
- (UIImage *) stretchWithCap:(UIEdgeInsets)insets;


/**
 生成图片缩略图
 
 @param size 传入缩略图尺寸
 @return 返回缩略图
 */
- (UIImage *) creatThumbnailWithSize:(CGSize)size;


/**
 图片设置圆角
 
 @param radius 传入圆角半径
 @return 返回完成图片
 */
- (UIImage *) setCornerRadius:(CGFloat)radius;


/**
 图片设置圆角和边框
 
 @param radius 传入圆角半径
 @param borderWidth 传入边框宽度
 @param borderColor 传入边框颜色
 @return 返回完成图片
 */
- (UIImage *) setCornerRadius:(CGFloat)radius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor;


/**
 图片旋转指定度数
 
 @param degree 传入度数（不是π）
 @return 返回完成图片
 */
- (UIImage *) rotatedWithDegree:(CGFloat)degree;

@end

