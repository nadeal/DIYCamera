//
//  WaterMarkView.h
//  DIYCamera
//
//  Created by A Pang on 2020/7/14.
//  Copyright © 2020 Moses Pang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, WaterMarkMode) {
    WaterModeHorizon,
    WaterModeVertical
};

@interface WaterMarkView : UIView



-(instancetype) initWaterMarkWithMode:(WaterMarkMode) mode img:(UIImage*) objImg;





@end

NS_ASSUME_NONNULL_END
