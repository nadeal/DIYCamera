//
//  WaterMarkView.m
//  DIYCamera
//
//  Created by A Pang on 2020/7/14.
//  Copyright © 2020 Moses Pang. All rights reserved.
//

#import "WaterMarkView.h"
#import "Macro.h"
#import "KMGestureRecognizer.h"

@interface WaterMarkView()
{
    
    UIView *contentView;
    UIView *bottomView;
    
    UIImageView *contentImgView;
    UIImageView *markImgView;
    
    UIButton *cancelBtn, *confirmBtn;
    WaterMarkMode viewMode;
    
    UIImage *getImg;
}

@property (strong, nonatomic) KMGestureRecognizer *customGestureRecognizer;

- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer;
- (void)handleTap:(UITapGestureRecognizer *)recognizer;
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer;
- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer;
- (void)handleCustomGestureRecognizer:(KMGestureRecognizer *)recognizer;

- (void)bindPan:(UIImageView *)imgVCustom;
- (void)bindPinch:(UIImageView *)imgVCustom;
- (void)bindRotation:(UIImageView *)imgVCustom;
- (void)bindTap:(UIImageView *)imgVCustom;
- (void)bindLongPress:(UIImageView *)imgVCustom;
- (void)bindSwipe;
- (void)bingCustomGestureRecognizer;
- (void)layoutUI;


@end


@implementation WaterMarkView



-(instancetype) initWaterMarkWithMode:(WaterMarkMode)mode img:(nonnull UIImage *)objImg {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    if (self) {
        getImg = objImg;
        viewMode = mode;
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(10*W_UNIT, kStatusBarHeight + 10*H_UNIT, SCREEN_W - 20*W_UNIT, SCREEN_H - kStatusBarHeight - 10*H_UNIT - kTabbarBottomHeight - 60*H_UNIT)];
    contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [self addSubview:contentView];

    bottomView = [[UIView alloc] initWithFrame:CGRectMake(contentView.frame.origin.x, CGRectGetMaxY(contentView.frame), SCREEN_W, 50*H_UNIT)];
    bottomView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    [self addSubview:bottomView];
    
    //
    if (viewMode == WaterModeHorizon) {
//
//        //横向模式
//
        contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 250, 400)];
        contentImgView.backgroundColor = [UIColor clearColor];
        contentImgView.contentMode = UIViewContentModeScaleAspectFit;
        contentImgView.image = getImg;
        contentImgView.userInteractionEnabled = YES;
        [self addSubview:contentImgView];
//
        markImgView = [[UIImageView alloc] initWithFrame:CGRectMake((contentImgView.frame.size.width - 110)/2.0f, (contentImgView.frame.size.height - 70)/2.0f, 110, 70)];
        markImgView.backgroundColor = [UIColor clearColor];
        markImgView.contentMode = UIViewContentModeScaleAspectFit;
        markImgView.image = [UIImage imageNamed:@"车牌遮挡"];
        markImgView.userInteractionEnabled = YES;
        markImgView.transform = CGAffineTransformMakeRotation(M_PI/2);
        [contentImgView addSubview:markImgView];
//
//
    } else {
//
//        //竖向模式
        CGSize imgSize = getImg.size;
        
        float viewHeight = imgSize.height*SCREEN_W/imgSize.width;
        
        contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight + 50*H_UNIT, SCREEN_W, viewHeight)];
        contentImgView.backgroundColor = [UIColor clearColor];
        contentImgView.contentMode = UIViewContentModeScaleAspectFit;
        contentImgView.image = getImg;
        contentImgView.userInteractionEnabled = YES;
        [self addSubview:contentImgView];
        
        markImgView = [[UIImageView alloc] initWithFrame:CGRectMake((contentImgView.frame.size.width - 110)/2.0f, (contentImgView.frame.size.height - 70)/2.0f, 110, 70)];
        markImgView.backgroundColor = [UIColor clearColor];
        markImgView.contentMode = UIViewContentModeScaleAspectFit;
        markImgView.image = [UIImage imageNamed:@"车牌遮挡"];
        markImgView.userInteractionEnabled = YES;
        markImgView.transform = CGAffineTransformMakeRotation(M_PI/2);
        [contentImgView addSubview:markImgView];
        
        
    }
    
    
    
    
    
    //图片视图 contentImgView
//    UIImage *img = [UIImage imageNamed:@"01"];
//    CGFloat cornerRadius = img.size.width;
//    contentImgView = [[UIImageView alloc] initWithImage:img];
//    contentImgView.frame = CGRectMake(20.0, 20.0,
//                                      img.size.width, img.size.height);
//    contentImgView.userInteractionEnabled = YES;
//    contentImgView.layer.masksToBounds = YES;
////    contentImgView.layer.cornerRadius = cornerRadius;
//    contentImgView.layer.borderWidth = 2.0;
//    contentImgView.layer.borderColor = [UIColor grayColor].CGColor;
//    [self addSubview:contentImgView];

    //图片视图 markImgView
//    img = [UIImage imageNamed:@"火箭头"];
//    cornerRadius = img.size.width;
//    markImgView = [[UIImageView alloc] initWithImage:img];
//    markImgView.frame = CGRectMake(20.0, 40.0 + contentImgView.frame.size.height,
//                              cornerRadius * 2, cornerRadius * 2);
//    markImgView.userInteractionEnabled = YES;
//    markImgView.layer.masksToBounds = YES;
//    markImgView.layer.cornerRadius = cornerRadius;
//    markImgView.layer.borderWidth = 2.0;
//    markImgView.layer.borderColor = [UIColor orangeColor].CGColor;
//
//
//    UIImageView * tempImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    tempImg.backgroundColor = [UIColor clearColor];
//    [markImgView addSubview:tempImg];
//
//    [self addSubview:markImgView];


//    [self bindPan:contentImgView];
//    [self bindPinch:contentImgView];
//    [self bindRotation:contentImgView];
//    [self bindTap:contentImgView];
//    [self bindLongPress:contentImgView];

    [self bindPan:markImgView];
    [self bindPinch:markImgView];
    [self bindRotation:markImgView];
    [self bindTap:markImgView];
    [self bindLongPress:markImgView];

    //为了处理手势识别优先级的问题，这里需先绑定自定义挠痒手势
    [self bingCustomGestureRecognizer];
    [self bindSwipe];
     
}


#pragma mark - 处理手势操作
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
    CGPoint translation = [recognizer translationInView:self];
    //NSLog(@"%@", NSStringFromCGPoint(translation));
    recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self];

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        //计算速度向量的长度，当他小于200时，滑行会很短
        CGPoint velocity = [recognizer velocityInView:self];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult); //e.g. 397.973175, slideMult: 1.989866

        //基于速度和速度因素计算一个终点
        float slideFactor = 0.1 * slideMult;
        CGPoint finalPoint = CGPointMake(center.x + (velocity.x * slideFactor),
                                         center.y + (velocity.y * slideFactor));
        //限制最小［cornerRadius］和最大边界值［self.view.bounds.size.width - cornerRadius］，以免拖动出屏幕界限
        finalPoint.x = MIN(MAX(finalPoint.x, cornerRadius),
                           self.bounds.size.width - cornerRadius);
        finalPoint.y = MIN(MAX(finalPoint.y, cornerRadius),
                           self.bounds.size.height - cornerRadius);

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
        contentImgView.center = newPoint;

        newPoint.y += 40.0;
        markImgView.center = newPoint;
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
        contentImgView.center = newPoint;

        newPoint.x += 40.0;
        markImgView.center = newPoint;
    };

    positionOperation();
}


#pragma mark - 绑定手势操作
/**
 *  绑定拖动手势
 *
 *  @param imgVCustom 绑定到图片视图对象实例
 */
- (void)bindPan:(UIImageView *)imgVCustom {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    [imgVCustom addGestureRecognizer:recognizer];
}

/**
 *  绑定捏合手势
 *
 *  @param imgVCustom 绑定到图片视图对象实例
 */
- (void)bindPinch:(UIImageView *)imgVCustom {
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
- (void)bindRotation:(UIImageView *)imgVCustom {
    UIRotationGestureRecognizer *recognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleRotation:)];
    [imgVCustom addGestureRecognizer:recognizer];
}

/**
 *  绑定点按手势
 *
 *  @param imgVCustom 绑定到图片视图对象实例
 */
- (void)bindTap:(UIImageView *)imgVCustom {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTap:)];
    //使用一根手指双击时，才触发点按手势识别器
    recognizer.numberOfTapsRequired = 2;
    recognizer.numberOfTouchesRequired = 1;
    [imgVCustom addGestureRecognizer:recognizer];
}

/**
 *  绑定长按手势
 *
 *  @param imgVCustom 绑定到图片视图对象实例
 */
- (void)bindLongPress:(UIImageView *)imgVCustom {
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
    [self addGestureRecognizer:recognizer];
    [recognizer requireGestureRecognizerToFail:_customGestureRecognizer]; //设置以自定义挠痒手势优先识别

    //向左轻扫手势
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(handleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:recognizer];
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
    [self addGestureRecognizer:_customGestureRecognizer];
}













/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
