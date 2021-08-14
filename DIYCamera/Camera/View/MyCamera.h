//
//  MyCamera.h
//  CameraPreview
//
//  Created by 高明阳 on 2020/12/12.
//  Copyright © 2020 高明阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol MyCameraDelegate <NSObject>

- (void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

@interface MyCamera : NSObject
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, assign) id<MyCameraDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isFrontCamera;
@property (nonatomic, copy) dispatch_queue_t captureQueue;

@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
/**预览图层*/
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
/// 当前焦距    默认最小值1  最大值6
@property (nonatomic, assign) CGFloat videoZoomFactor;

- (instancetype)initWithCameraPosition:(AVCaptureDevicePosition)cameraPosition captureFormat:(int)captureFormat andImageView:(UIView *)pickView;

- (void)startUp;

- (void)startCapture;

- (void)stopCapture;

- (void)changeCameraInputDeviceisFront:(BOOL)isFront didFinishChangeBlock:(void(^)())block;

//检查是否有授权相机
+ (BOOL)checkAuthority;

/**
 *  点击对焦
 *
 *  @param devicePoint
 */
- (void)focusInPoint:(CGPoint)devicePoint;

/**
 *  开启对焦监听 默认YES
 *
 *  @param
 */
- (void)setFocusObserver:(BOOL)yes;

/**
 *  切换闪光灯模式
 *
 *  @param sender
 */
- (void)switchFlashMode:(UIButton*)sender;

/**关闭闪光灯*/
- (void)turnOffFlashMode:(UIButton*)sender;


@end


