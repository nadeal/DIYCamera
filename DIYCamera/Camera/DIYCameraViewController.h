//
//  DIYuCameraViewController.h
//  DIYCamera
//
//  Created by Billy Pang on 2018/8/1.
//  Copyright © 2018年 Moses Pang. All rights reserved.
//

#import "BaseViewController.h"

@interface DIYCameraViewController : BaseViewController


@property (nonatomic,strong) NSString *pageString;
@property (nonatomic,assign) BOOL isSinglePhoto;//是否单次拍摄

@property (nonatomic,assign) NSInteger picIndex;

/**
 是否横屏
 */
@property (nonatomic, assign) BOOL isHorizontal;

@end
