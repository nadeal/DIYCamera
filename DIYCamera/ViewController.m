//
//  ViewController.m
//  DIYCamera
//
//  Created by Billy on 2021/8/14.
//

#import "ViewController.h"
#import "Macro.h"
#import "DIYCameraViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    
    
    
    
    
}

-(void) initUI {
    
    UIButton *oneBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 80, 40)];
    [oneBtn setTitle:@"横屏拍照" forState:UIControlStateNormal];
    [oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [oneBtn addTarget:self action:@selector(onTakePhotoBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:oneBtn];
    
    UIButton *twoBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 100, 80, 40)];
    [twoBtn setTitle:@"竖屏拍照" forState:UIControlStateNormal];
    [twoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [twoBtn addTarget:self action:@selector(onTakePhotoBtnPressed2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twoBtn];
    
}

-(void) onTakePhotoBtnPressed {
    
    DIYCameraViewController *vc = [[DIYCameraViewController alloc] init];
    vc.isHorizontal = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void) onTakePhotoBtnPressed2 {
    
    DIYCameraViewController *vc = [[DIYCameraViewController alloc] init];
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
