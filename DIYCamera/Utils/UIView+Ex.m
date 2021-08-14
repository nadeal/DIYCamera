//
//  UIView+Ex.m
//  DIYCamera
//
//  Created by Billy Pang on 2018/6/19.
//  Copyright © 2018年 YDZ. All rights reserved.
//

#import "UIView+Ex.h"

@implementation UIView (Ex)

//重写x属性的 getter方法，返回控件的x值
- (CGFloat)x{ return self.frame.origin.x; }
//重写x属性的 setter方法 设置控件的x值
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
}
- (CGFloat)y
{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
    
}
- (CGFloat)width{
    return self.frame.size.width;
    
}
- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    
}

- (CGFloat)height{
    return self.frame.size.height;
    
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
}

-(CGFloat)right{
    
    return CGRectGetMaxX(self.frame);
}

-(void)setRight:(CGFloat)right{
    
    CGRect frame = self.frame;
    frame.origin.x = [self right] - [self width];
    self.frame = frame;
}

-(CGFloat)bottom{
    
    return CGRectGetMaxY(self.frame);
}

-(void)setBottom:(CGFloat)bottom{

    CGRect frame = self.frame;
    frame.origin.y = [self bottom] - [self height];
    self.frame = frame;
}

-(CGFloat)centerX{
    
    return self.center.x;
}

-(void)setCenterX:(CGFloat)centerX{
    
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(CGFloat)centerY{
    
    return self.center.y;
}

-(void)setCenterY:(CGFloat)centerY{
    
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

-(UIViewController*)viewController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];

        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;

    } while (nextResponder != nil);

    return nil;
}

-(UITableView *)tableView
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];

        if ([nextResponder isKindOfClass:[UITableView class]])
            return (UITableView*)nextResponder;

    } while (nextResponder != nil);

    return nil;
}

- (void)setBorderWithCornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor
                             type:(UIRectCorner)corners {
    
    //    UIRectCorner type = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    
    //1. 加一个layer 显示形状
    CGRect rect = CGRectMake(borderWidth/2.0, borderWidth/2.0,
                             CGRectGetWidth(self.frame)-borderWidth, CGRectGetHeight(self.frame)-borderWidth);
    CGSize radii = CGSizeMake(cornerRadius, borderWidth);
    
    //create path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = borderColor.CGColor;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    
    shapeLayer.lineWidth = borderWidth;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    [self.layer addSublayer:shapeLayer];
    
    
    
    
    //2. 加一个layer 按形状 把外面的减去
    CGRect clipRect = CGRectMake(0, 0,
                                 CGRectGetWidth(self.frame)-1, CGRectGetHeight(self.frame)-1);
    CGSize clipRadii = CGSizeMake(cornerRadius, borderWidth);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:clipRect byRoundingCorners:corners cornerRadii:clipRadii];
    
    CAShapeLayer *clipLayer = [CAShapeLayer layer];
    clipLayer.strokeColor = borderColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    clipLayer.lineWidth = 1;
    clipLayer.lineJoin = kCALineJoinRound;
    clipLayer.lineCap = kCALineCapRound;
    clipLayer.path = clipPath.CGPath;
    
    self.layer.mask = clipLayer;
}


- (UIView*)subViewOfClassName:(NSString*) className {
    for (UIView *subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        UIView *resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}






@end


