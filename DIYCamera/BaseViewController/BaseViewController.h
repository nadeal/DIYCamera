//
//  BaseViewController.h
//  DIYCamera
//
//  Created by YDZ on 16/7/5.
//  Copyright © 2016年 Billy Pang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface BaseViewController : UIViewController
{
    UIView *_tipView;
    MBProgressHUD *_hud;
    UIActivityIndicatorView *_activityView;
    
    UIView *navigationBarView;
    UIButton *myLeftBtn;
    UIButton *myRightBtn;
    UILabel *centerTitleLabel;
    UILabel *navigationBottomLine;
    
}


#pragma mark NavigationBar

//@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIImageView *navigationBgImgView;//导航栏背景图

@property (nonatomic, strong) UIButton *leftBarBtn;
@property (nonatomic, strong) UIButton *rightBarBtn;

@property (nonatomic, strong) UILabel *barTitleLabel;

-(void) setGrayLeftBtn;
-(void) onLeftBarBtnPressed;
-(void) onRightBarBtnPressed;

-(void) onLeftBtnPressed;
-(void) onRightBtnPressed;
- (void)setStatusBarBackgroundColor:(UIColor *)color;


- (void)showLoading:(BOOL)show;

//显示加载提示
- (void)showHUD:(NSString *)title;
- (void)showHUDText:(NSString *)title;
-(void) showSmallText:(NSString*) txt font:(int) fontsize;

//隐藏HUD
- (void)hideHUD;
- (void)hideHUDDelay:(float) second;

//完成加载提示
- (void)comleteHUD:(NSString *)title;

- (void) goToNoNetworkPage;


-(void) setStatusBarTextWhiteColor:(BOOL) isWhite;

-(BOOL) onNetworkStatusAlive;



@end
