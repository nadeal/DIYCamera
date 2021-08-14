//
//  UIImage+DIYScale.h
//  ReaderProject
//
//  Created by Billy Pang on 2019/1/11.
//  Copyright © 2019年 PMX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DIYScale)

// 高效图片压缩
+ (NSData *)compressWithOrgImg:(UIImage *)img;
// 轻度压缩
+ (NSData *) compressLightlyWithOrgImg:(UIImage *)img;


- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

/**压缩到指定值以内*/
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;








@end

NS_ASSUME_NONNULL_END
