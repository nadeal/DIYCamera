//
//  MyCamera.m
//  CameraPreview
//
//  Created by 高明阳 on 2020/12/12.
//  Copyright © 2020 高明阳. All rights reserved.
//

#import "MyCamera.h"
#import "Macro.h"

#define Focus @"Focus"
@interface MyCamera()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property (strong, nonatomic) AVCaptureDeviceInput *backCameraInput;//后置摄像头输入
@property (strong, nonatomic) AVCaptureDeviceInput *frontCameraInput;//前置摄像头输入

@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureDevice *camera;

@property (assign, nonatomic) AVCaptureDevicePosition cameraPosition;
@property (assign, nonatomic) int captureFormat;

@property (nonatomic, assign) BOOL isManualFocus;//判断是否手动对焦
@property (nonatomic, strong) UIImageView *focusImageView;

@end

@implementation MyCamera

- (instancetype)initWithCameraPosition:(AVCaptureDevicePosition)cameraPosition captureFormat:(int)captureFormat andImageView:(UIView *)pickView {
    if (self = [super init]) {
        self.cameraPosition = cameraPosition;
        self.captureFormat = captureFormat;
        
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        self.previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.frame = pickView.frame;
        self.previewLayer.masksToBounds = YES;
        
        //加入对焦框
        [self initfocusImageWithParent:pickView];
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:device];
        [self setFocusObserver:YES];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.cameraPosition = AVCaptureDevicePositionFront;
        self.captureFormat = kCVPixelFormatType_32BGRA;
    }
    return self;
}

/**
 *  对焦的框
 */
- (void)initfocusImageWithParent:(UIView *)view;
{
    if (self.focusImageView) {
        return;
    }
    self.focusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_focus_x"]];
    self.focusImageView.alpha = 0;
    if (view.superview!=nil) {
        [view.superview addSubview:self.focusImageView];
    }else{
        self.focusImageView = nil;
    }
}


- (void)subjectAreaDidChange:(NSNotification *)notification {
    //先进行判断是否支持控制对焦
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.isFocusPointOfInterestSupported &&[device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error =nil;
        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问，
        [device lockForConfiguration:&error];
        [device setFocusMode:AVCaptureFocusModeAutoFocus];
        [self focusAtPoint:self.focusImageView.superview.center];
        //操作完成后，记得进行unlock。
        [device unlockForConfiguration];
    }
}

/*
 检查是否有相机权限
 */
+ (BOOL)checkAuthority
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}


- (void)startUp {
    [self startCapture];
}

- (void)startCapture {
    dispatch_async(self.captureQueue, ^{
        if (![self.captureSession isRunning]) {
            [self.captureSession startRunning];
        }
    });
}

- (void)stopCapture {
    dispatch_async(self.captureQueue, ^{
        if ([self.captureSession isRunning]) {
            [self.captureSession stopRunning];
        }
    });
    
}

-(void) setVideoOrientation:(AVCaptureVideoOrientation)videoOrientation {
    _videoOrientation = videoOrientation;
    if (_videoConnection) {
        [_videoConnection setVideoOrientation:videoOrientation];
    }
}

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        
        if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
            _captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
        } else if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetiFrame1280x720]) {
            _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
        } else {
            _captureSession.sessionPreset = AVCaptureSessionPreset640x480;
        }
        
        
        AVCaptureDeviceInput *deviceInput = self.isFrontCamera ? self.frontCameraInput:self.backCameraInput;
        
        if ([_captureSession canAddInput: deviceInput]) {
            [_captureSession addInput: deviceInput];
        }
        
        if ([_captureSession canAddOutput:self.videoOutput]) {
            [_captureSession addOutput:self.videoOutput];
        }
        
        [self.videoConnection setVideoOrientation:self.videoOrientation];
        if (self.videoConnection.supportsVideoMirroring && self.isFrontCamera) {
            self.videoConnection.videoMirrored = YES;
        }else {
            self.videoConnection.videoMirrored = NO;
        }
        
        [_captureSession beginConfiguration]; // the session to which the receiver's AVCaptureDeviceInput is added.
        if ( [deviceInput.device lockForConfiguration:NULL] ) {
            [deviceInput.device setActiveVideoMinFrameDuration:CMTimeMake(1, 30)];
            [deviceInput.device unlockForConfiguration];
        }
        [_captureSession commitConfiguration]; //
    }
    return _captureSession;
}

//后置摄像头输入
- (AVCaptureDeviceInput *)backCameraInput {
    if (_backCameraInput == nil) {
        NSError *error;
        _backCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        if (error) {
            NSLog(@"获取后置摄像头失败~");
        }
    }
    self.camera = _backCameraInput.device;
    return _backCameraInput;
}

//前置摄像头输入
- (AVCaptureDeviceInput *)frontCameraInput {
    if (_frontCameraInput == nil) {
        NSError *error;
        _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        if (error) {
            NSLog(@"获取前置摄像头失败~");
        }
    }
    self.camera = _frontCameraInput.device;
    return _frontCameraInput;
}

//返回前置摄像头
- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

//返回后置摄像头
- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

//切换前后置摄像头
- (void)changeCameraInputDeviceisFront:(BOOL)isFront didFinishChangeBlock:(void(^)())block{
    
    if (isFront) {
        [self.captureSession stopRunning];
        [self.captureSession removeInput:self.backCameraInput];
        if ([self.captureSession canAddInput:self.frontCameraInput]) {
            [self.captureSession addInput:self.frontCameraInput];
        }
        self.cameraPosition = AVCaptureDevicePositionFront;
    }else {
        [self.captureSession stopRunning];
        [self.captureSession removeInput:self.frontCameraInput];
        if ([self.captureSession canAddInput:self.backCameraInput]) {
            [self.captureSession addInput:self.backCameraInput];
        }
        self.cameraPosition = AVCaptureDevicePositionBack;
    }
    
    if (block) {
        block();
    }
    
    AVCaptureDeviceInput *deviceInput = isFront ? self.frontCameraInput:self.backCameraInput;
    
    [self.captureSession beginConfiguration]; // the session to which the receiver's AVCaptureDeviceInput is added.
    if ( [deviceInput.device lockForConfiguration:NULL] ) {
        [deviceInput.device setActiveVideoMinFrameDuration:CMTimeMake(1, 30)];
        [deviceInput.device unlockForConfiguration];
    }
    [self.captureSession commitConfiguration];
    
    self.videoConnection.videoOrientation = self.videoOrientation;
    if (self.videoConnection.supportsVideoMirroring) {
        self.videoConnection.videoMirrored = isFront;
    }
    [self.captureSession startRunning];
}

//用来返回是前置摄像头还是后置摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    //返回和视频录制相关的所有默认设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //遍历这些设备返回跟position相关的设备
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)camera {
    if (!_camera) {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if ([device position] == self.cameraPosition)
            {
                _camera = device;
            }
        }
    }
    return _camera;
}

- (AVCaptureVideoDataOutput *)videoOutput {
    if (!_videoOutput) {
        //输出
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
        [_videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:_captureFormat] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        [_videoOutput setSampleBufferDelegate:self queue:self.captureQueue];
    }
    return _videoOutput;
}

//录制的队列
- (dispatch_queue_t)captureQueue {
    if (_captureQueue == nil) {
        _captureQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    }
    return _captureQueue;
}

//视频连接
- (AVCaptureConnection *)videoConnection {
    _videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    _videoConnection.automaticallyAdjustsVideoMirroring =  NO;
    
    return _videoConnection;
}

- (BOOL)isFrontCamera {
    return self.cameraPosition == AVCaptureDevicePositionFront;
}

/**
 *  点击对焦
 *
 *  @param devicePoint
 */
#pragma mark 点击对焦
- (void)focusInPoint:(CGPoint) devicePoint
{
    if (CGRectContainsPoint(_previewLayer.bounds, devicePoint) == NO) {
        return;
    }
    self.isManualFocus = YES;
    [self focusImageAnimateWithCenterPoint:devicePoint];
    devicePoint = [self convertToPointOfInterestFromViewCoordinates:devicePoint];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusImageAnimateWithCenterPoint:(CGPoint)point {
    self.focusImageView.hidden = NO;
    self.focusImageView.alpha = 0.f;
    [self.focusImageView setCenter:point];
    self.focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    __weak typeof(self) weak = self;
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        weak.focusImageView.alpha = 1.f;
        weak.focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            weak.focusImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            weak.isManualFocus = NO;
        }];
    }];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    CGSize size = self.focusImageView.superview.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [device setFocusPointOfInterest:focusPoint];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        [device unlockForConfiguration];
    }
    [self setFocusCursorWithPoint:point];
}

-(void)setFocusCursorWithPoint:(CGPoint) point {
    //下面是手触碰屏幕后对焦的效果
    self.focusImageView.center = point;
    self.focusImageView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.focusImageView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.focusImageView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            self.focusImageView.hidden = YES;
        }];
    }];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    
    dispatch_async(_captureQueue, ^{
        AVCaptureDevice *device = self.camera;//[self.inputDevice device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
            {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
            {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        }
        else
        {
            LogOut(@"%@", error);
        }
    });
}

/**
 *  外部的point转换为camera需要的point(外部point/相机页面的frame)
 *
 *  @param viewCoordinates 外部的point
 *
 *  @return 相对位置的point
 */
- (CGPoint) convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates {
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = _previewLayer.bounds.size;
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = self.previewLayer;
    
    if([[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize]) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for(AVCaptureInputPort *port in [[self.captureSession.inputs lastObject]ports]) {
            if([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if([[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect]) {
                    if(viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if(point.x >= blackBar && point.x <= blackBar + x2) {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if(point.y >= blackBar && point.y <= blackBar + y2) {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if([[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                    if(viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                    
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

#pragma -mark Observer
- (void)setFocusObserver:(BOOL)yes
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device && [device isFocusPointOfInterestSupported]) {
        if (yes) {
            [device addObserver:self forKeyPath:Focus options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        }else{
            [device removeObserver:self forKeyPath:Focus context:nil];
        }
    }else{
        ShowAlert(@"你的设备没有照相机");
    }
}

/**
 *  切换闪光灯模式
 *  （切换顺序：最开始是auto，然后是off，最后是on，一直循环）
 *  @param sender: 闪光灯按钮
 */
- (void)switchFlashMode:(UIButton*)sender
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (!captureDeviceClass) {
        ShowAlert(@"您的设备没有拍照功能");
        return;
    }
    NSString *imgStr = @"";
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if ([device hasFlash]) {
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
            imgStr = @"检测-闪光灯开";
            
            [device setTorchMode:AVCaptureTorchModeOn];//开

        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeAuto;
            imgStr = @"检测-闪光灯自动";
            
            [device setTorchMode:AVCaptureTorchModeAuto];//关

        } else if (device.flashMode == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeOff;
            imgStr = @"检测-闪光灯关";
            
            [device setTorchMode:AVCaptureTorchModeOff];//关

        }
        if (sender) {
            [sender setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        }
    } else {
        ShowAlert(@"您的设备没有闪光灯功能");
    }
    [device unlockForConfiguration];
}

/**关闭闪光灯*/
- (void)turnOffFlashMode:(UIButton*)sender{
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (!captureDeviceClass) {
        ShowAlert(@"您的设备没有拍照功能");
        return;
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if ([device hasFlash]) {
        
        device.flashMode = AVCaptureFlashModeOff;
        [device setTorchMode:AVCaptureTorchModeOff];//关
        [sender setImage:[UIImage imageNamed:@"检测-闪光灯关"] forState:UIControlStateNormal];
    }
    [device unlockForConfiguration];
}

//最小缩放值 焦距
- (CGFloat)minZoomFactor {
    CGFloat minZoomFactor = 1.0;
    if (@available(iOS 11.0, *)) {
        minZoomFactor = self.camera.minAvailableVideoZoomFactor;
    }
    return minZoomFactor;
}

//最大缩放值 焦距
- (CGFloat)maxZoomFactor {
    CGFloat maxZoomFactor = self.camera.activeFormat.videoMaxZoomFactor;
    if (@available(iOS 11.0, *)) {
        maxZoomFactor = self.camera.maxAvailableVideoZoomFactor;
    }
    if (maxZoomFactor > 5) {
        maxZoomFactor = 5.0;
    }
    return maxZoomFactor;
}

/**当前焦距*/
-(void)setVideoZoomFactor:(CGFloat)videoZoomFactor{
    NSError *error = nil;
    if (videoZoomFactor <= self.maxZoomFactor &&
        videoZoomFactor >= self.minZoomFactor) {
        if ([self.camera lockForConfiguration:&error]) {
            self.camera.videoZoomFactor = videoZoomFactor;
            [self.camera unlockForConfiguration];
        }else{
            NSLog(@"调节焦距失败: %@", error);
        }
    }
}

#pragma mark -- 回调
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if([self.delegate respondsToSelector:@selector(didOutputVideoSampleBuffer:)])
    {
        [self.delegate didOutputVideoSampleBuffer:sampleBuffer];
    }

}

- (void)dealloc
{
    if ([_captureSession isRunning]) {
        [_captureSession stopRunning];
    }
    LogOut(@"照相机管理人释放了");
    _captureSession = nil;
    [self setFocusObserver:NO];
    [_previewLayer removeFromSuperlayer];
    _previewLayer = nil;
    
    _captureQueue = nil;
    _backCameraInput = nil;
    _frontCameraInput = nil;
    _videoOutput = nil;
    _videoConnection = nil;
    _camera = nil;
    _focusImageView = nil;
}

@end
