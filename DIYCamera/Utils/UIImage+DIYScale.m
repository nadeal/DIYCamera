//
//  UIImage+DIYScale.m
//  ReaderProject
//
//  Created by Billy Pang on 2019/1/11.
//  Copyright © 2019年 PMX. All rights reserved.
//

#import "Macro.h"
#import "UIImage+DIYScale.h"

@implementation UIImage (DIYScale)


//高度压缩
+ (NSData *)compressWithOrgImg:(UIImage *)img {
    
    int maxLength = 500 * 1024;
    CGFloat compress = 0.9f;
    NSData *data = UIImageJPEGRepresentation(img, compress);
    
    while (data.length > maxLength && compress > 0.01) {
        compress -= 0.02f;
        data = UIImageJPEGRepresentation(img, compress);
    }
    
    return data;
}

//轻度压缩
+ (NSData *) compressLightlyWithOrgImg:(UIImage *)img {
    @autoreleasepool {
        
        NSData *imageData = UIImageJPEGRepresentation(img, 1);
        float length = imageData.length;
        length = length/1024;
        // 裁剪比例
        CGFloat cout = 0.5;
        
        // 压缩比例
        CGFloat imgCout = 0.1;
        
        if(length > 25000){ // 25M以上的图片
            cout = 0.1;
            imgCout = 0;
        }else if(length > 10000){ // 10M以上的图片
            cout = 0.4;
            imgCout = 1;
        }else if (length > 5000) { // 5M以上的图片
            cout = 0.5;
            imgCout = 1;
        }else if (length > 1500) { // 如果原图大于1.5M就换一个压缩级别
            cout = 0.7;
            imgCout = 0.7;
        }else if (length > 1000) {
            cout = 0.8;
            imgCout = 0.8;
        }else if (length > 500) {
            cout = 0.8;
            imgCout = 0.8;
        }else if (length >100) { // 小于500k的不用裁剪
            
            imageData = UIImageJPEGRepresentation(img, 50 / imageData.length);
            float length = imageData.length;
            length = length/1024;
            return imageData;
        } else {
            
            imageData = UIImageJPEGRepresentation(img, 0.5);
            float length = imageData.length;
            length = length/1024;
            return imageData;
        }
        // 按裁剪比例裁剪
        UIImage *compressImage =  [img imageByScalingAndCroppingForSize:CGSizeMake(img.size.width * cout, img.size.height *cout)];
        // 那压缩比例压缩
        imageData = UIImageJPEGRepresentation(compressImage, imgCout);
        
        length= imageData.length / 1024;
        return imageData;
    }
    
}

// 裁剪
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}
@end
