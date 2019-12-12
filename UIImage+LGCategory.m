//
//  UIImage+LGCategory.m
//  Category
//
//  Created by 李国 on 2019/12/12.
//  Copyright © 2019 央戈科技. All rights reserved.
//

#import "UIImage+LGCategory.h"

@implementation UIImage (LGCategory)


#pragma mark - 类方法
/**
 由颜色生成图片
 
 @param color 传入颜色
 @return 返回完成图片
 */
+ (UIImage *) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 生成动态图片
 
 @param gifData 传入gif图片的二进制数据
 @return 返回动态图片
 */
+(UIImage *) imageWithGifData:(NSData *)gifData
{
    if (!gifData) return nil;
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef) gifData, nil);
    size_t count = CGImageSourceGetCount(source);
    
    UIImage * gifImage;
    if (count <= 1)
    {
        gifImage = [[UIImage alloc] initWithData:gifData];
    }
    else
    {
        NSMutableArray *images = [NSMutableArray array];
        for (size_t i = 0; i < count; i++)
        {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, nil);
            [images addObject:[UIImage imageWithCGImage:image]];
            CGImageRelease(image);
        }
        
        // 在这里可以调整gif速度
        NSTimeInterval duration = (0.1f) * count;
        gifImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    return gifImage;
}


/**
 创建水印图片
 
 @param waterMark 传入水印文字
 @param size 传入图片大小
 @return 返回水印图片
 */
+(UIImage *) imageWithWaterMark:(NSString *)waterMark size:(CGSize)size;
{
    // 设置水印间距和角度
    CGFloat horizontalSpace = 100;
    CGFloat verticalSpace = 100;
    CGFloat angle =  M_PI_2 / 3;
    
    // 设置富文本属性
    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *color = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    NSDictionary * attr = @{NSFontAttributeName: font, NSForegroundColorAttributeName :color};
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:waterMark attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName :color}];
    
    // 获取图片和单个水印文字大小
    CGFloat textW = attrStr.size.width;
    CGFloat textH = attrStr.size.height;
    
    CGFloat imageW = size.width;
    CGFloat imageH = size.height;
    CGFloat sqrtLength = sqrt(imageW*imageW + imageH*imageH);
    
    // 开启上下文
    UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 操作上下文旋转
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(imageW/2, imageH/2));
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(angle));
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-imageW/2, -imageH/2));
    
    //计算需要绘制的列数和行数
    int horCount = sqrtLength / (textW + horizontalSpace) + 1;
    int verCount = sqrtLength / (textH + verticalSpace) + 1;
    
    //此处计算出需要绘制水印文字的起始点，由于水印区域要大于图片区域所以起点在原有基础上移
    CGFloat orignX = -(sqrtLength-imageW)/2;
    CGFloat orignY = -(sqrtLength-imageH)/2;
    
    //在每列绘制时X坐标叠加
    CGFloat tempOrignX = orignX;
    CGFloat tempOrignY = orignY;
    
    // 循环添加水印
    for (int i = 0; i < horCount * verCount; i++)
    {
        [waterMark drawInRect:CGRectMake(tempOrignX, tempOrignY, textW, textH) withAttributes:attr];
        if (i % horCount == 0 && i != 0)
        {
            tempOrignX = orignX;
            tempOrignY += (textH + verticalSpace);
        }
        else
        {
            tempOrignX += (textW + horizontalSpace);
        }
    }
    
    // 生成图片并关闭上下文
    UIImage * waterMarkImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRestoreGState(context);
    
    return waterMarkImage;
}


#pragma mark - 实例方法
/**
 生成图片缩略图
 
 @param size 传入缩略图尺寸
 @return 返回缩略图
 */
- (UIImage *) creatThumbnailWithSize:(CGSize)size
{
    CGSize imageSize = self.size;
    if(imageSize.width < imageSize.height)
    {
        imageSize = CGSizeMake(size.width, size.width/imageSize.width * imageSize.height);
    }
    else
    {
        imageSize = CGSizeMake(size.height/imageSize.height * imageSize.width, size.height);
    }
    
    if (imageSize.width <= 0 || imageSize.height <= 0) return nil;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 图片缩放至某尺寸
 
 @param size 传入缩放尺寸
 @return 返回完成图片
 */
- (UIImage *) zoomToSize:(CGSize)size
{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        scaleFactor = widthFactor > heightFactor ? widthFactor : heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    UIGraphicsEndImageContext();
    
    return newImage;
}


/**
 图片缩放至某比例
 
 @param scale 传入缩放比例
 @return 返回完成图片
 */
- (UIImage *) zoomToScale:(CGFloat)scale
{
    CGSize size = CGSizeMake(self.size.width *scale, self.size.height * scale);
    if (size.width <= 0 || size.height <= 0) return nil;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 裁剪图片某个区域
 
 @param rect 传入裁剪区域
 @return 返回完成图片
 */
- (UIImage *) clipWithRect:(CGRect)rect
{
    rect.origin.x *= self.scale;
    rect.origin.y *= self.scale;
    rect.size.width *= self.scale;
    rect.size.height *= self.scale;
    
    if (rect.size.width <= 0 || rect.size.height <= 0) return nil;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return image;
}


/**
 图片拉伸保护区域（多用于聊天框拉伸）
 
 @param insets 设置不被拉伸区域
 @return 返回完成图片
 */
- (UIImage *) stretchWithCap:(UIEdgeInsets)insets
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f)
    {
        return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    
    return [self stretchableImageWithLeftCapWidth:insets.left topCapHeight:insets.top];
}


/**
 图片设置圆角
 
 @param radius 传入圆角半径
 @return 返回完成图片
 */
- (UIImage *) setCornerRadius:(CGFloat)radius
{
    return [self setCornerRadius:radius BorderWidth:0 BorderColor:nil];
}


/**
 图片设置圆角和边框
 
 @param radius 传入圆角半径
 @param borderWidth 传入边框宽度
 @param borderColor 传入边框颜色
 @return 返回完成图片
 */
- (UIImage *) setCornerRadius:(CGFloat)radius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2)
    {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0)
    {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = kCGLineJoinMiter;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 图片旋转指定度数
 
 @param degree 传入度数（不是π）
 @return 返回完成图片
 */
- (UIImage *) rotatedWithDegree:(CGFloat)degree
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    CGSize rotatedSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degree * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
