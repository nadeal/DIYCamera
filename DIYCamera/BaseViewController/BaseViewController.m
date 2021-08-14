//
//  BaseViewController.m
//  DIYCamera
//
//  Created by YDZ on 16/7/5.
//  Copyright © 2016年 Billy Pang.com. All rights reserved.
//

#import "BaseViewController.h"
#import "Macro.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.hidesBottomBarWhenPushed = YES;
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.hidesBottomBarWhenPushed = NO;
//}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //self.navigationController.navigationBar.translucent = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];//黑色
    
    //设置NavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    //@{}代表Dictionary
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    // 方式一
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = THEME_COLOR;
    [self preferredStatusBarStyle];
    
    navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, kStatusBarAndNavigationBarHeight)];
    navigationBarView.backgroundColor = [UIColor whiteColor];
    navigationBarView.hidden = YES;
    [self.view addSubview:navigationBarView];
    
    _navigationBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, kStatusBarAndNavigationBarHeight)];
    _navigationBgImgView.backgroundColor = [UIColor clearColor];
    _navigationBgImgView.contentMode = UIViewContentModeScaleToFill;
    [navigationBarView addSubview:_navigationBgImgView];
    
    
    navigationBottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, navigationBarView.height - SINGLE_LINE_WIDTH, SCREEN_W, SINGLE_LINE_WIDTH)];
    navigationBottomLine.backgroundColor = LINE_GRAY2;
    [navigationBarView addSubview:navigationBottomLine];
    
    centerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80*W_UNIT, kStatusBarHeight - (isPad? 20 : 0), SCREEN_W - 160*W_UNIT, 44*H_UNIT)];
    centerTitleLabel.backgroundColor = [UIColor clearColor];
    if (isPad) {
        centerTitleLabel.font = [UIFont boldSystemFontOfSize:22];
    } else
    {
        centerTitleLabel.font = BOLD_FONT(17);
    }
    centerTitleLabel.textColor = [UIColor blackColor];
    centerTitleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBarView addSubview:centerTitleLabel];
    
    myLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight + 3*H_UNIT, 60*W_UNIT - (isPad? 20 : 0), 40)];
    [myLeftBtn setImage:[UIImage imageNamed:@"temp_back"] forState:UIControlStateNormal];
    myLeftBtn.backgroundColor = [UIColor clearColor];
    [myLeftBtn addTarget:self action:@selector(onLeftBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:myLeftBtn];
    
    
    myRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 60*W_UNIT, kStatusBarHeight + 4*H_UNIT, 60*W_UNIT, 40*H_UNIT)];
    myRightBtn.backgroundColor = [UIColor clearColor];
    [myRightBtn setTitle:@"" forState:UIControlStateNormal];
    myRightBtn.titleLabel.font = NORMAL_FONT(15);
    myRightBtn.hidden = YES;
    [myRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myRightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [myRightBtn addTarget:self action:@selector(onRightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:myRightBtn];
    
}

-(void) setGrayLeftBtn {
    navigationBarView.backgroundColor = [UIColor whiteColor];
    [myLeftBtn setImage:[UIImage imageNamed:@"返回-左箭头-灰"] forState:UIControlStateNormal];
}

-(void) setStatusBarTextWhiteColor:(BOOL) isWhite {
    
    if (isWhite) {
        //设置全局状态栏字体颜色为白色
        //
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
}

-(void) onLeftBtnPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onRightBtnPressed {
    
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    centerTitleLabel.text = self.title;
}

- (void)showLoading:(BOOL)show
{
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:self.view.bounds];
        _tipView.backgroundColor = [UIColor whiteColor];
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_tipView.frame.size.height - 20)/2 - 100*H_UNIT, _tipView.frame.size.width*W_UNIT, 20*H_UNIT)];
        loadLabel.text = @"";
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.textAlignment = NSTextAlignmentCenter;
        [_tipView addSubview:loadLabel];
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.frame = CGRectMake(100*W_UNIT, - 100*H_UNIT, 20*W_UNIT, 20*H_UNIT);
        [_activityView setBackgroundColor:[UIColor blackColor]];
        [_tipView addSubview:_activityView];
    }
    
    if (show) {
        [self.view addSubview:_tipView];
    }else {
        if (_tipView.superview) {
            [_tipView removeFromSuperview];
        }
    }
}
//显示加载提示
- (void)showHUD:(NSString *)title
{
    [_activityView startAnimating];
    _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.subviews.lastObject animated:YES];
//    _hud.animationType = MBProgressHUDAnimationZoomIn;
    _hud.dimBackground = NO;
    _hud.progress = 0.1;
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.detailsLabelText = title;
    _hud.labelFont = NORMAL_FONT(15);
}

- (void)showHUDText:(NSString *)title
{
    [_activityView startAnimating];
    if (_hud != nil) {
        [_hud removeFromSuperview];
        _hud = nil;
    }
    _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.subviews.lastObject animated:YES];
    _hud.dimBackground = NO;
    _hud.progress = 0.1;
    _hud.mode = MBProgressHUDModeText;
    _hud.detailsLabelText = title;
    _hud.labelFont = NORMAL_FONT(15);
}

-(void) showSmallText:(NSString*) txt font:(int) fontsize {
    [_activityView startAnimating];
    if (_hud != nil) {
        [_hud removeFromSuperview];
        _hud = nil;
    }
    _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.subviews.lastObject animated:YES];
    _hud.dimBackground = NO;
    _hud.progress = 0.1;
    
    _hud.labelFont = NORMAL_FONT(fontsize);
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = txt;
}

//隐藏HUD
- (void)hideHUD
{
    [_activityView stopAnimating];
    [_hud hide:YES afterDelay:1.0];
}

- (void)hideHUDDelay:(float) second
{
    [_activityView stopAnimating];
    [_hud hide:YES afterDelay:second];
}

-(void)stopHUD
{
    
}
//37x-Checkmark.png
//完成加载提示
- (void)comleteHUD:(NSString *)title
{
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.detailsLabelText = title;
    _hud.labelFont = NORMAL_FONT(15);
    //隐藏
    [self hideHUD];
}

#pragma mark 无网络
- (void) goToNoNetworkPage {
    
    
}

-(BOOL) onNetworkStatusAlive {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
