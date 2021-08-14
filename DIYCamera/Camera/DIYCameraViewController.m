//
//  DIYuCameraViewController.m
//  DIYCamera
//
//  Created by Billy Pang on 2018/8/1.
//  Copyright © 2018年 Billy. All rights reserved.
//

#import "DIYCameraViewController.h"
#import "Macro.h"
#import "KMGestureRecognizer.h"
#import <CoreMotion/CoreMotion.h>

#import "MyCamera.h"
#import <AVFoundation/AVFoundation.h>

//横屏时的比例变化
#define WIDTH_UNIT   [UIScreen mainScreen].bounds.size.width/667.0
#define FIX_HEIGHT   375.0*SCREEN_W/667.0
#define HEIGHT_UNIT  FIX_HEIGHT/375.0

@interface DIYCameraViewController () <UIGestureRecognizerDelegate,MyCameraDelegate,AVCaptureMetadataOutputObjectsDelegate,CAAnimationDelegate>
{
    BOOL isDrawLayout;
    
    NSString *saveFilePath;
    UIImageView *markImgView;
    UIImageView *circleRemarkImgView;
    UIView *contentView;
    UIView *remarkContentView;
}

@property (strong, nonatomic) KMGestureRecognizer *customGestureRecognizer;

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *pickView;
@property (nonatomic,strong) MyCamera *camera;

@property (nonatomic,strong) UIButton *useBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *takeBtn;
@property (nonatomic,strong) UIButton *changeBtn;
@property (nonatomic,strong) UIButton *flashBtn;
@property (nonatomic,strong) UIButton *retakeBtn;//重拍
@property (nonatomic,strong) UIButton *editPicBtn;
@property (nonatomic,strong) UIButton *remarkBtn;//标记

@property (nonatomic,strong) UIView *picContentView;
@property (nonatomic,strong) UIImageView *photoView;

@property (nonatomic,strong) UIView *remindView;
@property (nonatomic,strong) UIImageView *remindImgView;
@property (nonatomic,strong) UILabel *remindLabel;


@property (nonatomic,strong) CMMotionManager *motionManager;

/**
 *  记录开始的缩放比例
 */
@property(nonatomic,assign)CGFloat beginGestureScale;
/**
 * 最后的缩放比例
 */
@property(nonatomic,assign)CGFloat effectiveScale;

@end

@implementation DIYCameraViewController
/**
 *  在页面结束或出现记得开启／停止摄像
 *
 *  @param animated
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.isHorizontal) {
        appdelegate.allowRotation = 1;
    }
    
    if (!isDrawLayout) {
        isDrawLayout = YES;
        if (self.isHorizontal) {
            [self initHorizontalLayout];
        } else {
            [self initLayout];
        }
        
        _picContentView.hidden = YES;
        
//        [self onShowPic];
    }
    
    [_camera startCapture];
}

-(void) viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_camera stopCapture];
    
    if (self.isHorizontal) {
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdelegate.allowRotation = 0;
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            [self changeOrientation:UIInterfaceOrientationPortrait];
        }
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}

/**
 *    强制竖屏
 */
- (void)changeOrientation:(UIInterfaceOrientation)orientation
{
    int val = (int)orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark 释放资源
- (void)dealloc {
    [_motionManager stopDeviceMotionUpdates];
    _motionManager = nil;
    
    [self.camera stopCapture];
    [_remindView removeFromSuperview];
//    _remindView = nil;
//    [_remindImgView removeFromSuperview];
//    _remindImgView = nil;
    
    [_retakeBtn removeObserver:self forKeyPath:@"hidden"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.effectiveScale = 1.0;
    
    //在适当的位置启动重力引擎
    if (!TARGET_IPHONE_SIMULATOR) {
        [self performSelector:@selector(starMotionManager) withObject:nil afterDelay:1.5];
        [self performSelector:@selector(onHideTipMethod) withObject:nil afterDelay:3];
    }
    
    if (self.isHorizontal) {
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = YES;
        [UIDevice.currentDevice setValue:@(UIDeviceOrientationLandscapeRight) forKey:@"orientation"];
    }
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
}

-(void) onHideTipMethod {
//    [_remindImgView stopAnimating];
//    _remindView.hidden = YES;
    
    [self.motionManager stopDeviceMotionUpdates];
}

- (UIImageView *)pickView {
    if (_pickView == nil) {
        _pickView = [[UIImageView alloc] init];
        if (self.isHorizontal) {
            _pickView.frame = CGRectMake(20*WIDTH_UNIT, 0, SCREEN_W, SCREEN_H);
        } else {
            _pickView.frame = CGRectMake(0,0, SCREEN_W, SCREEN_H - 120*H_UNIT);
        }
        _pickView.clipsToBounds = YES;
    }
    return _pickView;
}

#pragma mark 竖屏
-(void) initLayout {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0,kStatusBarHeight + 40*H_UNIT, SCREEN_W, SCREEN_H - 100*H_UNIT - kStatusBarHeight - kTabbarBottomHeight)];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.pickView];
    self.bgView.clipsToBounds = YES;
    
    self.camera = [[MyCamera alloc] initWithCameraPosition:AVCaptureDevicePositionBack captureFormat:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange andImageView:self.pickView];
    self.camera.delegate = self;
    self.camera.videoOrientation = AVCaptureVideoOrientationPortrait;//横屏的时候
    [self.bgView.layer insertSublayer:self.camera.previewLayer atIndex:0];
    
    
    //拍照按钮
    if (IS_iPhoneX) {
        
        CGFloat takePhotoBtnWidth = 50*W_UNIT;
        _takeBtn = [self buildButton:CGRectMake((SCREEN_W - takePhotoBtnWidth)/2.0f, SCREEN_H - kTabbarBottomHeight - takePhotoBtnWidth, takePhotoBtnWidth, takePhotoBtnWidth)
                        normalImgStr:@"照片-拍照-X"
                     highlightImgStr:@"照片-拍照-X"
                      selectedImgStr:@""  parentView:self.view];
    } else {
        CGFloat takePhotoBtnWidth = 50*WIDTH_UNIT;
        _takeBtn = [self buildButton:CGRectMake((SCREEN_W - takePhotoBtnWidth)/2.0f, SCREEN_H - kTabbarBottomHeight - takePhotoBtnWidth, takePhotoBtnWidth, takePhotoBtnWidth)
                        normalImgStr:@"照片-拍照"
                     highlightImgStr:@"照片-拍照"
                      selectedImgStr:@""  parentView:self.view];
    }
    [_takeBtn addTarget:self action:@selector(onTakeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //完成  使用按钮
    CGRect finishRect = CGRectMake(SCREEN_W-65*W_UNIT, _takeBtn.centerY - 16*H_UNIT, 50*W_UNIT, 32*H_UNIT);
    _useBtn = [[UIButton alloc] initWithFrame:finishRect];
    _useBtn.backgroundColor = CHECK_TXT_PURPLE;
    _useBtn.layer.cornerRadius = 16*HEIGHT_UNIT;
    [_useBtn setTitle:@"使用" forState:UIControlStateNormal];
    [_useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _useBtn.titleLabel.font = PingFang_Regular_FONT(16);
    _useBtn.hidden = YES;
    [_useBtn addTarget:self action:@selector(onFinishBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_useBtn];
    
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20*W_UNIT, _takeBtn.centerY - 20*H_UNIT, 80*W_UNIT, 40*H_UNIT)];
    _cancelBtn.backgroundColor = [UIColor clearColor];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = PingFang_Regular_FONT(16);
    [_cancelBtn addTarget:self action:@selector(onCancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    _retakeBtn = [[UIButton alloc] initWithFrame:_cancelBtn.frame];
    _retakeBtn.backgroundColor = [UIColor clearColor];
    [_retakeBtn setTitle:@"重拍" forState:UIControlStateNormal];
    _retakeBtn.hidden = YES;
    [_retakeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _retakeBtn.titleLabel.font = PingFang_Regular_FONT(16);
    [_retakeBtn addTarget:self action:@selector(onRetakeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_retakeBtn];
    
    _editPicBtn = [[UIButton alloc] initWithFrame:_cancelBtn.frame];
    _editPicBtn.x = CGRectGetMaxX(_retakeBtn.frame) + 10*W_UNIT;
    _editPicBtn.backgroundColor = [UIColor clearColor];
    [_editPicBtn setTitle:@"水印" forState:UIControlStateNormal];
    _editPicBtn.hidden = YES;
    [_editPicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _editPicBtn.titleLabel.font = PingFang_Regular_FONT(16);
    [_editPicBtn addTarget:self action:@selector(onEditPicBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editPicBtn];
    
    _remarkBtn = [[UIButton alloc] initWithFrame:_cancelBtn.frame];
    _remarkBtn.x = CGRectGetMaxX(_editPicBtn.frame) + 10*W_UNIT;
    _remarkBtn.backgroundColor = [UIColor clearColor];
    [_remarkBtn setTitle:@"标记" forState:UIControlStateNormal];
    _remarkBtn.hidden = YES;
    [_remarkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _remarkBtn.titleLabel.font = PingFang_Regular_FONT(16);
    [_remarkBtn addTarget:self action:@selector(onRemarkBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_remarkBtn];
    
    [_retakeBtn addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    _picContentView = [[UIView alloc] initWithFrame:CGRectMake(self.bgView.x, self.bgView.y, self.bgView.width, self.bgView.height)];
    _picContentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_picContentView];
    
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, self.bgView.height)];
    _photoView.center = self.bgView.center;
    _photoView.backgroundColor = [UIColor clearColor];
    _photoView.contentMode = UIViewContentModeScaleToFill;
    _photoView.clipsToBounds = YES;
    _picContentView.hidden = YES;
    _photoView.x = 0;
    _photoView.y = 0;
    
    [_picContentView addSubview:_photoView];
    
    
    CGFloat buttonW = 40*W_UNIT;
    _flashBtn = [self buildButton:CGRectMake(0, IS_iPhoneX?kStatusBarHeight + 0*H_UNIT : 12*H_UNIT, buttonW, buttonW)
                            normalImgStr:@"检测-闪光灯关"
                         highlightImgStr:@""
                          selectedImgStr:@""
                              parentView:self.view];
    [_flashBtn addTarget:self action:@selector(onFlashBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _changeBtn = [self buildButton:CGRectMake(SCREEN_W-80*H_UNIT, _takeBtn.centerY - 20*H_UNIT, 80*W_UNIT, 40*H_UNIT)
                               normalImgStr:@"相机-调转"
                            highlightImgStr:@""
                             selectedImgStr:@""
                                 parentView:self.view];
    [_changeBtn addTarget:self action:@selector(onChangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 横屏
 */
- (void)initHorizontalLayout
{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(40*WIDTH_UNIT, 0, SCREEN_W-120*WIDTH_UNIT, SCREEN_H)];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.pickView];
    self.bgView.clipsToBounds = YES;
    
    self.camera = [[MyCamera alloc] initWithCameraPosition:AVCaptureDevicePositionBack captureFormat:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange andImageView:self.pickView];
    self.camera.delegate = self;
    self.camera.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    [self.bgView.layer insertSublayer:self.camera.previewLayer atIndex:0];
    
    
    //拍照按钮
    if (IS_iPhoneX) {
        
        CGFloat takePhotoBtnWidth = 85*WIDTH_UNIT;
        _takeBtn = [self buildButton:CGRectMake(SCREEN_W - takePhotoBtnWidth, (SCREEN_H - takePhotoBtnWidth)/2, takePhotoBtnWidth, takePhotoBtnWidth)
                        normalImgStr:@"照片-拍照-X"
                     highlightImgStr:@"照片-拍照-X"
                      selectedImgStr:@""  parentView:self.view];
    } else {
        CGFloat takePhotoBtnWidth = 80*WIDTH_UNIT;
        _takeBtn = [self buildButton:CGRectMake(SCREEN_W - takePhotoBtnWidth, (SCREEN_H - takePhotoBtnWidth)/2, takePhotoBtnWidth, takePhotoBtnWidth)
                        normalImgStr:@"照片-拍照"
                     highlightImgStr:@"照片-拍照"
                      selectedImgStr:@""  parentView:self.view];
    }
    [_takeBtn addTarget:self action:@selector(onTakeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //完成  使用按钮
    CGRect finishRect = CGRectMake(SCREEN_W-65*WIDTH_UNIT, 20*HEIGHT_UNIT, 50*WIDTH_UNIT, 32*HEIGHT_UNIT);
    _useBtn = [[UIButton alloc] initWithFrame:finishRect];
    _useBtn.backgroundColor = CHECK_TXT_PURPLE;
    _useBtn.layer.cornerRadius = 16*HEIGHT_UNIT;
    [_useBtn setTitle:@"使用" forState:UIControlStateNormal];
    [_useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _useBtn.titleLabel.font = [UIFont systemFontOfSize:14*WIDTH_UNIT];
    _useBtn.hidden = YES;
    [_useBtn addTarget:self action:@selector(onFinishBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_useBtn];
    
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-80*WIDTH_UNIT, SCREEN_H-60*HEIGHT_UNIT, 80*WIDTH_UNIT, 40*HEIGHT_UNIT)];
    _cancelBtn.backgroundColor = [UIColor clearColor];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16*WIDTH_UNIT];
//    _cancelBtn.transform=CGAffineTransformMakeRotation(M_PI/2);
    [_cancelBtn addTarget:self action:@selector(onCancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    _retakeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-80*WIDTH_UNIT, SCREEN_H-60*HEIGHT_UNIT, 80*WIDTH_UNIT, finishRect.size.height)];
    _retakeBtn.backgroundColor = [UIColor clearColor];
    [_retakeBtn setTitle:@"重拍" forState:UIControlStateNormal];
    _retakeBtn.hidden = YES;
    [_retakeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _retakeBtn.titleLabel.font = [UIFont systemFontOfSize:16*WIDTH_UNIT];
//    _retakeBtn.transform=CGAffineTransformMakeRotation(M_PI/2);
    [_retakeBtn addTarget:self action:@selector(onRetakeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_retakeBtn];
    
    _editPicBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-80*WIDTH_UNIT, CGRectGetMaxY(_retakeBtn.frame)-80*HEIGHT_UNIT, 80*WIDTH_UNIT, finishRect.size.height)];
    _editPicBtn.backgroundColor = [UIColor clearColor];
    [_editPicBtn setTitle:@"水印" forState:UIControlStateNormal];
    _editPicBtn.hidden = YES;
    [_editPicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _editPicBtn.titleLabel.font = [UIFont systemFontOfSize:16*WIDTH_UNIT];
//    _editPicBtn.transform=CGAffineTransformMakeRotation(M_PI/2);
    [_editPicBtn addTarget:self action:@selector(onEditPicBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editPicBtn];
    
    _remarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-80*WIDTH_UNIT, CGRectGetMaxY(_editPicBtn.frame)-80*HEIGHT_UNIT, 80*WIDTH_UNIT, finishRect.size.height)];
    _remarkBtn.backgroundColor = [UIColor clearColor];
    [_remarkBtn setTitle:@"标记" forState:UIControlStateNormal];
    _remarkBtn.hidden = YES;
    [_remarkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _remarkBtn.titleLabel.font = [UIFont systemFontOfSize:16*WIDTH_UNIT];
//    _remarkBtn.transform = CGAffineTransformMakeRotation(M_PI/2);
    [_remarkBtn addTarget:self action:@selector(onRemarkBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_remarkBtn];
    
    [_retakeBtn addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    _picContentView = [[UIView alloc] initWithFrame:CGRectMake(self.bgView.x, self.bgView.y, self.bgView.width, self.bgView.height)];
    _picContentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_picContentView];
    
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, self.bgView.height)];
    _photoView.center = self.bgView.center;
    _photoView.backgroundColor = [UIColor clearColor];
    _photoView.contentMode = UIViewContentModeScaleToFill;
    _photoView.clipsToBounds = YES;
    _picContentView.hidden = YES;
    _photoView.x = 0;
    _photoView.y = 0;
    
    [_picContentView addSubview:_photoView];
    
    
    CGFloat buttonW = 40*WIDTH_UNIT;
    _flashBtn = [self buildButton:CGRectMake(20*WIDTH_UNIT, 20*HEIGHT_UNIT, buttonW, buttonW)
                            normalImgStr:@"检测-闪光灯关"
                         highlightImgStr:@""
                          selectedImgStr:@""
                              parentView:self.view];
    [_flashBtn addTarget:self action:@selector(onFlashBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _changeBtn = [self buildButton:CGRectMake(SCREEN_W-80*WIDTH_UNIT, IS_iPhoneX?kStatusBarHeight + 12*HEIGHT_UNIT : 12*HEIGHT_UNIT, 80*WIDTH_UNIT, 40*HEIGHT_UNIT)
                               normalImgStr:@"相机-调转"
                            highlightImgStr:@""
                             selectedImgStr:@""
                                 parentView:self.view];
    [_changeBtn addTarget:self action:@selector(onChangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    
    
    
    
    
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:_retakeBtn]) {
        if ([keyPath isEqualToString:@"hidden"]) {
            _editPicBtn.hidden = _retakeBtn.isHidden;
            _remarkBtn.hidden = _retakeBtn.isHidden;
        }
    }
}

#pragma mark 拍照
-(void) onTakeBtnPressed {
    
    [self.camera stopCapture];
    UIImage *imageRet = [self getPartImage];
    if (imageRet) {
        
        [self.photoView setImage:imageRet];
        
        NSString *picScaledName = [NSString stringWithFormat:@"%@.jpg", [NSDate getCurrentMilliTimeStamp]];
        NSString *saveScaledPath = [NSString stringWithFormat:@"%@/%@", ApplicationDelegate.photoPath, picScaledName];
        NSData *imageData = UIImageJPEGRepresentation(imageRet, 1.0f);
        
        [imageData writeToFile:saveScaledPath atomically:YES];
        saveFilePath = saveScaledPath;

        self.takeBtn.hidden = YES;
        self.useBtn.hidden = NO;
        self.changeBtn.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.flashBtn.hidden = YES;
        self.retakeBtn.hidden = NO;
        self.picContentView.hidden = NO;
    }
    
}

#pragma mark -- 截取局部视图成一个图片
-(UIImage *)getPartImage{
    
    //获取上下文范围
    UIGraphicsBeginImageContext(self.bgView.bounds.size);
    //呈现
    [self.bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //根据当前上下文生成图片
    UIImage *allImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGRect rect = self.bgView.bounds;
    //根据CGRect裁剪图片
    UIImage *partImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(allImage.CGImage, rect)];
    //释放
    UIGraphicsEndImageContext();
    
    return partImage;
}

#pragma mark 编辑图片 水印
-(void) onEditPicBtnPressed:(UIButton*) btn {
    NSString *title = btn.currentTitle;
    if ([title isEqualToString:@"去除水印"]) {
        
        [btn setTitle:@"水印" forState:UIControlStateNormal];
        contentView.hidden = YES;
        
    } else if ([title isEqualToString:@"水印"]) {
        
        [btn setTitle:@"去除水印" forState:UIControlStateNormal];
        
        if (contentView == nil) {
            
            contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110*WIDTH_UNIT + 200*WIDTH_UNIT, 70*HEIGHT_UNIT + 200*HEIGHT_UNIT)];
            contentView.backgroundColor = [UIColor clearColor];
            contentView.userInteractionEnabled = YES;
            [_photoView addSubview:contentView];
            
            markImgView = [[UIImageView alloc] initWithFrame:CGRectMake(100*WIDTH_UNIT, 100*HEIGHT_UNIT, 110*WIDTH_UNIT, 70*HEIGHT_UNIT)];
            markImgView.backgroundColor = [UIColor clearColor];
            markImgView.contentMode = UIViewContentModeScaleAspectFit;
            markImgView.image = [UIImage imageNamed:@"水印"];
            markImgView.userInteractionEnabled = YES;
            [contentView addSubview:markImgView];
            _photoView.userInteractionEnabled = YES;
            
            
            [self bindPan:contentView];
            [self bindPinch:contentView];
            [self bindRotation:contentView];
            [self bindTap:contentView];
            //[self bindLongPress:contentView];

            [self bindOneTap:contentView];
            
            //为了处理手势识别优先级的问题，这里需先绑定自定义挠痒手势
            [self bingCustomGestureRecognizer];
            [self bindSwipe];
        } else {
            contentView.frame = CGRectMake(0, 0, 110*WIDTH_UNIT + 200*WIDTH_UNIT, 70*HEIGHT_UNIT + 200*HEIGHT_UNIT);
            contentView.transform = CGAffineTransformMakeScale(1, 1);
            
        }
        contentView.hidden = NO;
        
    }
}

-(void)onRemarkBtnPressed:(UIButton *)btn{
    
    NSString *title = btn.currentTitle;
    if ([title isEqualToString:@"去除标记"]) {
        
        [btn setTitle:@"标记" forState:UIControlStateNormal];
        remarkContentView.hidden = YES;
        
    } else if ([title isEqualToString:@"标记"]) {
        
        [btn setTitle:@"去除标记" forState:UIControlStateNormal];
        
        if (remarkContentView == nil) {
            
            remarkContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110*WIDTH_UNIT + 200*WIDTH_UNIT, 70*HEIGHT_UNIT + 200*HEIGHT_UNIT)];
            remarkContentView.backgroundColor = [UIColor clearColor];
            remarkContentView.userInteractionEnabled = YES;
            [_photoView addSubview:remarkContentView];
            
            circleRemarkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(100*WIDTH_UNIT, 100*HEIGHT_UNIT, 110*WIDTH_UNIT, 70*HEIGHT_UNIT)];
            circleRemarkImgView.backgroundColor = [UIColor clearColor];
            circleRemarkImgView.contentMode = UIViewContentModeScaleAspectFit;
            circleRemarkImgView.image = [UIImage imageNamed:@""];
            circleRemarkImgView.layer.cornerRadius = 3.f;
            circleRemarkImgView.layer.borderColor = [UIColor redColor].CGColor;
            circleRemarkImgView.layer.borderWidth = 2.f;
            circleRemarkImgView.userInteractionEnabled = YES;
            [remarkContentView addSubview:circleRemarkImgView];
            _photoView.userInteractionEnabled = YES;
            
            [self bindPan:remarkContentView];
            [self bindPinch:remarkContentView];
            [self bindRotation:remarkContentView];
            [self bindTap:remarkContentView];
            //[self bindLongPress:remarkContentView];

            [self bindOneTap:remarkContentView];
            
            //为了处理手势识别优先级的问题，这里需先绑定自定义挠痒手势
            [self bingCustomGestureRecognizer];
            [self bindSwipe];
        } else {
            remarkContentView.frame = CGRectMake(0, 0, 110*WIDTH_UNIT + 200*WIDTH_UNIT, 70*HEIGHT_UNIT + 200*HEIGHT_UNIT);
            remarkContentView.transform = CGAffineTransformMakeScale(1, 1);
            
        }
        remarkContentView.hidden = NO;
        
    }
}

#pragma mark 重拍
-(void) onRetakeBtnPressed {
    
    _picContentView.hidden = YES;
    _takeBtn.hidden = NO;
    _flashBtn.hidden = NO;
    _cancelBtn.hidden = NO;
    _useBtn.hidden = YES;
    _retakeBtn.hidden = YES;
    _changeBtn.hidden = NO;
    
    [self removeOperation];
}

#pragma mark -- 重置操作
-(void)removeOperation{
    
    [self.camera startCapture];
    
    //关闭闪光灯
    [self.camera turnOffFlashMode:_flashBtn];
    
    if ([_editPicBtn.titleLabel.text isEqualToString:@"去除水印"]) {
        [self onEditPicBtnPressed:_editPicBtn];
    }
    
    if ([_remarkBtn.titleLabel.text isEqualToString:@"去除标记"]) {
        [self onRemarkBtnPressed:_remarkBtn];
    }
}

#pragma mark 取消按钮
-(void) onCancelBtnPressed {
    
    if (_picContentView.hidden != YES) {
        _picContentView.hidden = YES;
        _useBtn.hidden = NO;
        _cancelBtn.hidden = NO;
        _useBtn.hidden = YES;
        _retakeBtn.hidden = YES;
        
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self releaseResourse];
    }
}

#pragma mark 完成 使用
-(void) onFinishBtnPressed {
    if (!_editPicBtn.isHidden) {
        CGSize size = _picContentView.frame.size;
        UIImage *image = [_photoView sl_imageByViewInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImg = image;
        NSData *getData = [UIImage compressWithOrgImg:newImg];
        [getData writeToFile:saveFilePath atomically:YES];
        UIImageWriteToSavedPhotosAlbum(newImg, nil, nil, nil);
    }
    _picContentView.hidden = YES;
    if ([self.pageString  isEqualToString:@"a"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"afanhui" object:self userInfo:@{@"image":saveFilePath}];
    } else if ([self.pageString isEqualToString:@"b"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bfanhui" object:self userInfo:@{@"image":saveFilePath}];
    } else if ([self.pageString isEqualToString:@"c"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cfanhui" object:self userInfo:@{@"image":saveFilePath}];
    } else if ([self.pageString isEqualToString:@"d"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dfanhui" object:self userInfo:@{@"image":saveFilePath}];
    } else if ([self.pageString isEqualToString:@"e"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"efanhui" object:self userInfo:@{@"image":saveFilePath, @"picIndex":@(self.picIndex)}];
    } else {
        if (saveFilePath != nil) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fanhui" object:self userInfo:@{@"image":saveFilePath, @"index":@"1000"}];//加入index键值对  用于CheckDetailViewController检测信息区分多拍和单拍，其他地方没用到
        } else {
            
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self releaseResourse];
    
}

-(void) releaseResourse {
    [_motionManager stopDeviceMotionUpdates];
    _motionManager = nil;
    
    [_camera stopCapture];
}

-(void) onFlashBtnPressed:(UIButton*) sender {
    [self.camera switchFlashMode:sender];
}

/**
 *  切换闪光灯按钮
 */
#pragma mark 切换闪光灯按钮
- (void)initFlashButton {
    
}

-(void) onChangeBtnPressed:(UIButton*) btn {
    
    btn.enabled = NO;
    btn.selected = !btn.selected;
    [self.camera changeCameraInputDeviceisFront:btn.selected didFinishChangeBlock:^{
        btn.enabled = YES;
    }];
}

/**
 *  点击对焦
 *
 *  @param touches
 *  @param event
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self.camera focusInPoint:point];
}

- (UIButton*)buildButton:(CGRect)frame
            normalImgStr:(NSString*)normalImgStr
         highlightImgStr:(NSString*)highlightImgStr
          selectedImgStr:(NSString*)selectedImgStr
              parentView:(UIView*)parentView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:highlightImgStr] forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:selectedImgStr] forState:UIControlStateSelected];
    }
    [parentView addSubview:btn];
    
    return btn;
}

-(void)starMotionManager {
    
    if (_motionManager == nil) {
        _motionManager = [CMMotionManager new];
    }
    
    if (_motionManager.deviceMotionAvailable) {
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            [self handleDeviceMotion:motion];
        }];
    }
}

#pragma mark 横竖屏
-(void)handleDeviceMotion:(CMDeviceMotion *)motion{
    
    double x = motion.gravity.x;
    
    double y = motion.gravity.y;
    
    if (fabs(y)>=fabs(x)) {
        
        if (y>=0) {
            
        } else {
            //竖屏
            // UIDeviceOrientationPortrait
//            _remindView.hidden = NO;
//            [_remindImgView startAnimating];
            
//            [self deviceOrientationDidChange];
            
        }
        
    } else {
        
        if (x >= 0) {
//            //LogOut(@"头向右");
        } else {
//            //LogOut(@"头向左");
            // 停止重力引擎
//            [_remindImgView stopAnimating];
//            _remindView.hidden = YES;
            
            [self.motionManager stopDeviceMotionUpdates];
            
//            [self deviceOrientationDidChange];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 处理手势操作
//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{

    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.view];
        CGPoint convertedLocation = [self.camera.previewLayer convertPoint:location fromLayer:self.camera.previewLayer.superlayer];
        if ( ! [self.camera.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }

    if ( allTouchesAreOnThePreviewLayer ) {
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }

        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);

//        CGFloat maxScaleAndCropFactor = [[self.camera.videoOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
//        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > 5.0)
            self.effectiveScale = 5.0;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.camera.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        self.camera.previewLayer.masksToBounds = YES;

        [CATransaction commit];

    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark 水印手势
/**
 *  处理拖动手势
 *
 *  @param recognizer 拖动手势识别器对象实例
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    //视图前置操作
    [recognizer.view.superview bringSubviewToFront:recognizer.view];

    CGPoint center = recognizer.view.center;
    CGFloat cornerRadius = recognizer.view.frame.size.width / 2;
    CGPoint translation = [recognizer translationInView:self.view];
    //NSLog(@"%@", NSStringFromCGPoint(translation));
    recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        //计算速度向量的长度，当他小于200时，滑行会很短
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult); //e.g. 397.973175, slideMult: 1.989866

        //基于速度和速度因素计算一个终点
        float slideFactor = 0.1 * slideMult;
        CGPoint finalPoint = CGPointMake(center.x + (velocity.x * slideFactor),
                                         center.y + (velocity.y * slideFactor));
        //限制最小［cornerRadius］和最大边界值［self.view.bounds.size.width - cornerRadius］，以免拖动出屏幕界限
//        finalPoint.x = MIN(MAX(finalPoint.x, cornerRadius),
//                           self.view.bounds.size.width - cornerRadius);
//        finalPoint.y = MIN(MAX(finalPoint.y, cornerRadius),
//                           self.view.bounds.size.height - cornerRadius);

        //使用 UIView 动画使 view 滑行到终点
        [UIView animateWithDuration:slideFactor*2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             recognizer.view.center = finalPoint;
                         }
                         completion:nil];
    }
}

/**
 *  处理捏合手势
 *
 *  @param recognizer 捏合手势识别器对象实例
 */
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    CGFloat scale = recognizer.scale;
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, scale, scale); //在已缩放大小基础下进行累加变化；区别于：使用 CGAffineTransformMakeScale 方法就是在原大小基础下进行变化
    recognizer.scale = 1.0;
}

/**
 *  处理旋转手势
 *
 *  @param recognizer 旋转手势识别器对象实例
 */
- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0.0;
}

/**
 *  处理点按手势
 *
 *  @param recognizer 点按手势识别器对象实例
 */
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    view.transform = CGAffineTransformMakeRotation(0.0);
    view.alpha = 1.0;
}

/**单击*/
-(void)handleOneTap:(UITapGestureRecognizer *)recognizer {
    
    if ([recognizer.view isEqual:contentView]) {
        
        CGPoint onePoint = [recognizer locationInView:_editPicBtn];
        CGPoint twoPoint = [recognizer locationInView:_useBtn];
        if (onePoint.x > 0 && onePoint.x < _editPicBtn.width && onePoint.y > 0 && onePoint.y < _editPicBtn.height) {
            
            [self onEditPicBtnPressed:_editPicBtn];
        }else if (twoPoint.x > 0 && twoPoint.x < _useBtn.width && twoPoint.y > 0 && twoPoint.y < _useBtn.height){
            
            [self onFinishBtnPressed];
        }
    }else if ([recognizer.view isEqual:remarkContentView]){
        
        CGPoint onePoint = [recognizer locationInView:_remarkBtn];
        CGPoint twoPoint = [recognizer locationInView:_useBtn];
        
        if (onePoint.x > 0 && onePoint.x < _remarkBtn.width && onePoint.y > 0 && onePoint.y < _remarkBtn.height) {
            
            [self onRemarkBtnPressed:_remarkBtn];
            
        }else if (twoPoint.x > 0 && twoPoint.x < _useBtn.width && twoPoint.y > 0 && twoPoint.y < _useBtn.height){
            
            [self onFinishBtnPressed];
        }
    }
    
}

/**
 *  处理长按手势
 *
 *  @param recognizer 点按手势识别器对象实例
 */
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    //长按的时候，设置不透明度为0.7
    recognizer.view.alpha = 0.7;
}

/**
 *  处理轻扫手势
 *
 *  @param recognizer 轻扫手势识别器对象实例
 */
- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    //代码块方式封装操作方法
    void (^positionOperation)() = ^() {
        CGPoint newPoint = recognizer.view.center;
        newPoint.y -= 20.0;
//        contentImgView.center = newPoint;

        newPoint.y += 40.0;
        contentView.center = newPoint;
    };

    //根据轻扫方向，进行不同控制
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionRight: {
            positionOperation();
            break;
        }
        case UISwipeGestureRecognizerDirectionLeft: {
            positionOperation();
            break;
        }
        case UISwipeGestureRecognizerDirectionUp: {
            break;
        }
        case UISwipeGestureRecognizerDirectionDown: {
            break;
        }
    }
}

/**
 *  处理自定义手势
 *
 *  @param recognizer 自定义手势识别器对象实例
 */
- (void)handleCustomGestureRecognizer:(KMGestureRecognizer *)recognizer {
    //代码块方式封装操作方法
    void (^positionOperation)() = ^() {
        CGPoint newPoint = recognizer.view.center;
        newPoint.x -= 20.0;
//        contentImgView.center = newPoint;

        newPoint.x += 40.0;
        contentView.center = newPoint;
    };

    positionOperation();
}


#pragma mark - 绑定手势操作
/**
 *  绑定拖动手势
 *
 *  @param imgVCustom 绑定到图片视图对象实例
 */
- (void)bindPan:(UIView *)imgVCustom {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    [imgVCustom addGestureRecognizer:recognizer];
}

/**
 *  绑定捏合手势
 *
 *  @param imgVCustom 绑定到图片视图对象实例
 */
- (void)bindPinch:(UIView *)imgVCustom {
    UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handlePinch:)];
    [imgVCustom addGestureRecognizer:recognizer];
    //[recognizer requireGestureRecognizerToFail:imgVCustom.gestureRecognizers.firstObject];
}

/**
 *  绑定旋转手势
 *
 *  @param imgVCustom 绑定到图片视图对象实例
 */
- (void)bindRotation:(UIView *)imgVCustom {
    UIRotationGestureRecognizer *recognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleRotation:)];
    [imgVCustom addGestureRecognizer:recognizer];
}

/**
 *  绑定点按手势
 *
 *  @param imgVCustom 绑定到图片视图对象实例
 */
- (void)bindTap:(UIView *)imgVCustom {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTap:)];
    //使用一根手指双击时，才触发点按手势识别器
    recognizer.numberOfTapsRequired = 2;
    recognizer.numberOfTouchesRequired = 1;
    [imgVCustom addGestureRecognizer:recognizer];
}

/**单击*/
-(void)bindOneTap:(UIView *)imgVCustom {
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleOneTap:)];
    //使用一根手指双击时，才触发点按手势识别器
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    [imgVCustom addGestureRecognizer:recognizer];
}

/**
 *  绑定长按手势
 *
 *  @param imgVCustom 绑定到图片视图对象实例
 */
- (void)bindLongPress:(UIView *)imgVCustom {
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    recognizer.minimumPressDuration = 0.5; //设置最小长按时间；默认为0.5秒
    [imgVCustom addGestureRecognizer:recognizer];
}

/**
 *  绑定轻扫手势；支持四个方向的轻扫，但是不同的方向要分别定义轻扫手势
 */
- (void)bindSwipe {
    //向右轻扫手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight; //设置轻扫方向；默认是 UISwipeGestureRecognizerDirectionRight，即向右轻扫
    [self.view addGestureRecognizer:recognizer];
    [recognizer requireGestureRecognizerToFail:_customGestureRecognizer]; //设置以自定义挠痒手势优先识别

    //向左轻扫手势
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(handleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizer];
    [recognizer requireGestureRecognizerToFail:_customGestureRecognizer]; //设置以自定义挠痒手势优先识别
}

/**
 *  绑定自定义挠痒手势；判断是否有三次不同方向的动作，如果有则手势结束，将执行回调方法
 */
- (void)bingCustomGestureRecognizer {
    //当 recognizer.state 为 UIGestureRecognizerStateEnded 时，才执行回调方法 handleCustomGestureRecognizer:

    //_customGestureRecognizer = [KMGestureRecognizer new];
    _customGestureRecognizer = [[KMGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(handleCustomGestureRecognizer:)];
    [self.view addGestureRecognizer:_customGestureRecognizer];
}

// handle sampleBuffer
- (void)projectionImagesWith:(CMSampleBufferRef)sampleBuffer {
    
    //NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVImageBuffer:imageBuffer];
    UIImage *image = [UIImage imageWithCIImage:ciImage];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.pickView.transform = CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale);
        weakSelf.pickView.image = image;
    });
}

- (void)projectionImagesWithImage:(UIImage *)image {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.pickView.image = image;
    });
}

// Delegate
- (void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    [self projectionImagesWith:sampleBuffer];
}

@end

