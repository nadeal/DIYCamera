//
//  UIView+Ex.h
//  DIYCamera
//
//  Created by Billy Pang on 2018/6/19.
//  Copyright © 2018年 YDZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (Ex)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, strong) UITableView *tableView;

- (void)setBorderWithCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor  type:(UIRectCorner)corners;

- (UIView*)subViewOfClassName:(NSString*) className;
@end


