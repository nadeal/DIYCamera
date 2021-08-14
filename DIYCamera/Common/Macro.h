//
//  Macro.h
//  Share
//
//  Created by ls on 15/8/10.
//  Copyright (c) 2015年 dllo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

//appdelegate
#define ApplicationDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_H ([UIScreen mainScreen].bounds.size.height)

#define W_UNIT [UIScreen mainScreen].bounds.size.width/375
#define FIX_H     667.0*SCREEN_W/375.0
//#define H_UNIT [UIScreen mainScreen].bounds.size.height/667
#define H_UNIT FIX_H/667.0

//横屏时
#define Page_W_UNIT [UIScreen mainScreen].bounds.size.width/667
#define Page_H_UNIT [UIScreen mainScreen].bounds.size.height/375

//
#define iOS14 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 14.0)
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define isIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] == 7.0)
#define iOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)

#define isPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad   ? YES : NO)
#define isPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? YES : NO)
#define isRetina ([[UIScreen mainScreen] scale] > 1 ? YES : NO)


//#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define IS_iPhoneX (kStatusBarHeight > 20.0f)

// status bar height.

//#define  kStatusBarHeight      (IS_iPhoneX ? 44.f : 20.f)

// Navigation bar height.

#define  kNavigationBarHeight  44.f

// Tabbar height.

#define  kTabbarHeight        (IS_iPhoneX ? (49.f+34.f) : 49.f)

// 若iphoneX  底部空白告诉
#define kTabbarBottomHeight      (IS_iPhoneX ? 34.f : 0)

// Tabbar safe bottom margin.

#define  kTabbarSafeBottomMargin        (IS_iPhoneX ? 34.f : 0.f)

// Status bar & navigation bar height.

#define  kStatusBarAndNavigationBarHeight  (IS_iPhoneX ? 88.f : 64.f)






//带有RGBA的颜色设置

#define ORGANECOLOR [UIColor colorWithRed:254./255. green:102./255. blue:52./225. alpha:1.]
#define BLUECOLOR [UIColor colorWithRed:38./255. green:140./255. blue:255./225. alpha:1.]
#define BGCOLOREBEBEB [UIColor colorWithRed:235./255. green:235./255. blue:235./225. alpha:1.]
#define COLOR111111 [UIColor colorWithRed:239./255. green:239./255. blue:244./255. alpha:1.0]
#define COLOR222222 [UIColor colorWithRed:223./255. green:196./255. blue:137./255. alpha:1.0]
#define COLOR333333 [UIColor colorWithRed:198./255. green:198./255. blue:204./255. alpha:1.0]
#define COLOR444444 [UIColor colorWithRed:224./255. green:224./255. blue:224./255. alpha:1.0]
#define COLOR555555 [UIColor colorWithRed:204./255. green:204./255. blue:204./255. alpha:1.0]
#define COLOR888888 [UIColor colorWithRed:115./255. green:115./255. blue:115./255. alpha:1.0]
#define COLOR404040 [UIColor colorWithRed:56./255. green:56./255. blue:56./255. alpha:1.0]
#define detailCOLOR [UIColor colorWithRed:173./255. green:168./255. blue:168./255. alpha:1.0]

#define COLOR777777 [UIColor colorWithRed:1./255. green:104./255. blue:215./255. alpha:1.0]

#define BACGUANG [UIColor colorWithRed:229./255. green:229./255. blue:229./255. alpha:1.0]

#define appKeyY @""
#define appSecretY @""

#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);

#define  WeakSelf()                 __weak typeof(self) weakSelf = self

#pragma mark 日志输出控制
#if DEBUG
//#define IS_NOT_LOG   TRUE                      /*======================不打印日志 */
#define IS_NOT_LOG   FALSE                       /*======================打印日志 */
#else
#define IS_NOT_LOG   TRUE                      /*======================不打印日志 */
#endif

#if IS_NOT_LOG

#define LogOut(format, ...)
#define LogInfo(...)

#else

#define LogOut(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#define LogInfo(...)  LogOut(__VA_ARGS__)

#endif


//单例 宏定义
// @interface
#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}


//UIAlertView
#define ShowAlert(title) [[[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kUserDefaults      [NSUserDefaults standardUserDefaults]


//APP版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//系统版本号
#define kSystemVersion [[UIDevice currentDevice] systemVersion]

//判断是否为iPhone
#define kISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define NetWork_VideoDir          @"VideoCache"

//判断是否为iPad
#define kISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//获取沙盒Document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒temp路径
#define kTempPath NSTemporaryDirectory()

//获取沙盒Cache路径
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//真机
#endif
#if TARGET_IPHONE_SIMULATOR
//模拟器
#endif

#define kRGBColor(r,  g,  b)                [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define kRGBAColor(r, g, b, a)           [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

#define kRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)        //随机色生成

#define kColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

// 由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)

//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:［NSBundle mainBundle]pathForResource:file ofType:ext］

//rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R,  G,  B,  A)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]


#define SINGLE_LINE_WIDTH (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET ((1 / [UIScreen mainScreen].scale) / 2)


#pragma mark 通知命名
#define kNotificationCenter [NSNotificationCenter defaultCenter]


#define RectMake(getX, getY, getWidth, getHeight)        CGRectMake(getX*W_UNIT, getY*H_UNIT, getWidth*W_UNIT, getHeight*H_UNIT)

#define BOLD_FONT(sizeNum)                        [UIFont fontWithName:@"Helvetica-Bold" size:sizeNum*W_UNIT]
#define NORMAL_FONT(size)                  [UIFont systemFontOfSize:size*W_UNIT]
#define PingFang_Regular_FONT(sizeNum)                  [UIFont fontWithName:@"PingFangSC-Regular" size:sizeNum*W_UNIT]
#define PingFang_Medium_FONT(sizeNum)                  [UIFont fontWithName:@"PingFangSC-Medium" size:sizeNum*W_UNIT]
#define PingFang_Semibold_FONT(sizeNum)                  [UIFont fontWithName:@"PingFangSC-Semibold" size:sizeNum*W_UNIT]

#define APP_PHOTOS_DIR                                           @"AppPhotos"
#define APP_PHOTOS_TMP_DIR                                           @"AppPhotosTemp"
#define APP_PDF                                                  @"AppPDF"

// 防止多次调用
#define kPreventRepeatClickTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
}); \



#define Compress_MaxSize      500*1024

//rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define THEME_COLOR            kRGBColor(92, 130, 240)
#define APP_BGCOLOR             kRGBColor(239, 239, 244)
#define CONTROL_BG_COLOR          kRGBColor(251, 251, 255)

//橙色按钮
#define BTN_ORANGE_FORBID        [UIColor colorWithRed:0.949 green:0.714 blue:0.553 alpha:1.00]
#define BTN_ORANGE_NORMAL        [UIColor colorWithRed:0.980 green:0.420 blue:0.047 alpha:1.00]
#define BTN_ORANGE_SELECTED      [UIColor colorWithRed:0.851 green:0.341 blue:0.004 alpha:1.00]

#define BTN_ORANGE_TITLE_FORBID       [UIColor colorWithRed:0.941 green:0.894 blue:0.863 alpha:1.00]

//蓝色按钮
#define BTN_BLUE_FORBID           [UIColor colorWithRed:0.792 green:0.800 blue:0.843 alpha:1.00]
#define BTN_BLUE_NORMAL         [UIColor colorWithRed:0.310 green:0.400 blue:0.898 alpha:1.00]
#define BTN_BLUE_SELECTED      [UIColor colorWithRed:0.208 green:0.298 blue:0.784 alpha:1.00]


#define FirstPageSelected             kRGBColor(92,130,240)
#define FirstPageNoSelected             kRGBColor(51,51,51)

#define LIGHT_BLUE                 kRGBColor(172,185,254)
#define LINE_GRAY                    [UIColor colorWithRed:180 green:180 blue:180 alpha:1.00]
#define LINE_GRAY2                  kRGBColor(229,229,229)
#define APP_LINE_COLOR                  kRGBColor(210,210,210)
#define LINE_GRAY3                   [UIColor colorWithRed:198./255. green:198./255. blue:204./255. alpha:1.0]

#define TEXT_BLACK                kRGBColor(27,27,27)
#define TEXT_GRAY                   kRGBColor(153,153,153)
#define TEXT_ORANGE             [UIColor colorWithRed:0.980 green:0.420 blue:0.047 alpha:1.00]
#define TEXT_CHECK_GRAY                   kRGBColor(187,187,187)
#define TEXT_GREEN                 [UIColor colorWithRed:0.000 green:0.620 blue:0.588 alpha:1.00]
#define TEXT_PURPLE                [UIColor colorWithRed:0.361 green:0.510 blue:0.941 alpha:1.00]


#define TEXT_PHOTO_TITLE_PURPLE                 [UIColor colorWithRed:0.369 green:0.369 blue:0.557 alpha:1.00]

#define ToolTipColorBlue                      [UIColor colorWithRed:0.122 green:0.157 blue:0.349 alpha:1.00]

#define LABEL_BG_ORANGE    [UIColor colorWithRed:0.980 green:0.420 blue:0.047 alpha:1.00]
#define LABEL_BG_GRAY                      [UIColor colorWithRed:0.937 green:0.937 blue:0.957 alpha:1.00]

#define LABEL_GRAY_102                kRGBColor(102,102,102)

#define CHECK_TXT_BLACK                kRGBColor(94,94,142)
#define CHECK_TXT_BLUE                 kRGBColor(92, 130, 240)
#define CHECK_TXT_PURPLE              kRGBColor(79, 102, 230)
#define VIN_HEAD_COLOR     [UIColor colorWithRed:0.937 green:0.937 blue:0.957 alpha:1.00]

#define btn_forbid_selected     kRGBColor(175, 187, 253)
#define Point_RED                            [UIColor colorWithRed:0.898 green:0.243 blue:0.263 alpha:1.00]

#define Btn_Normal_Orange                            [UIColor colorWithRed:0.980 green:0.420 blue:0.047 alpha:1.00]
#define Btn_Selected_Orange                           [UIColor colorWithRed:0.851 green:0.341 blue:0.004 alpha:1.00]
#define Btn_Forbid_Orange                              [UIColor colorWithRed:0.949 green:0.714 blue:0.553 alpha:1.00]

#define Btn_Normal_Dark_Blue                       [UIColor colorWithRed:0.310 green:0.400 blue:0.902 alpha:1.00]
#define Btn_Selected_Dark_Blue                      [UIColor colorWithRed:0.208 green:0.298 blue:0.784 alpha:1.00]
#define Btn_Forbid_Dark_Blue                         [UIColor colorWithRed:0.792 green:0.800 blue:0.843 alpha:1.00]

#define MAIN_YELLOW                                 [UIColor colorWithRed:253./255. green:235./255. blue:52./255. alpha:1.0]

#pragma mark 颜色设置

#define COLOR_0076FF                                   kRGBColor(0, 118, 255)
#define COLOR_009E96                                   [UIColor colorWithRed:0.000 green:0.620 blue:0.588 alpha:1.00]

#define COLOR_1B1B1B                                   kRGBColor(27, 27, 27)

#define COLOR_2E2E2E                                      UIColorFromRGB(0X2E2E2E)


#define COLOR_333333                                   kRGBColor(51, 51, 51)
#define COLOR_373737                                   kRGBColor(55, 55, 55)

#define COLOR_354CC8                                      [UIColor colorWithRed:0.208 green:0.298 blue:0.784 alpha:1.00]

#define COLOR_4A90E2                                        kRGBColor(74, 144, 226)
#define COLOR_486EDF                                       [UIColor colorWithRed:0.282 green:0.431 blue:0.875 alpha:1.00]

#define COLOR_5E5E8E                                  kRGBColor(94, 94, 142)
#define COLOR_5F5D92                                  kRGBColor(95, 93, 146)
#define COLOR_5C82F0                                   kRGBColor(92,130,240)


#define COLOR_68CEA7                                    [UIColor colorWithRed:0.408 green:0.808 blue:0.655 alpha:1.00]

#define COLOR_95A3F0                                    [UIColor colorWithRed:0.584 green:0.639 blue:0.941 alpha:1.00]

#define COLOR_DAE0FF                                    [UIColor colorWithRed:0.855 green:0.878 blue:1.000 alpha:1.00]

#define COLOR_BFBFBF                                       kRGBColor(191, 191, 191)



#define COLOR_6B82FF                                  kRGBColor(107, 130, 255)
#define COLOR_666870                                   kRGBColor(102, 104, 112)
#define COLOR_666666                                   kRGBColor(102, 102, 102)

#define COLOR_78A2D2                                   kRGBColor(120, 162, 210)

#define COLOR_8DB2FF                                   [UIColor colorWithRed:0.553 green:0.698 blue:1.000 alpha:1.00]
#define COLOR_87A0E8                                   kRGBColor(135, 160, 232)


#define COLOR_999999                                   kRGBColor(153, 153, 153)

#define COLOR_B58D60                                       kRGBColor(181, 141, 96)


#define COLOR_C5CEFA                                        [UIColor colorWithRed:0.773 green:0.808 blue:0.980 alpha:1.00]
#define COLOR_CACCD7                                   kRGBColor(202, 204, 215)
#define COLOR_C0D3F5                                             [UIColor colorWithRed:0.753 green:0.827 blue:0.961 alpha:1.00]

#define COLOR_D9E1FA                                        [UIColor colorWithRed:0.851 green:0.882 blue:0.980 alpha:1.00]

#define COLOR_E5E5E5                                  kRGBColor(229, 229, 229)

#define COLOR_E51C21                                kRGBColor(229, 28, 33)

#define COLOR_EFEFF4                                  kRGBColor(239, 239, 244)

#define COLOR_FBFBFF                                   kRGBColor(251, 251, 255)

#define COLOR_FA6B0C                                   [UIColor colorWithRed:0.980 green:0.420 blue:0.047 alpha:1.00]
#define COLOR_FAF2F1                                    [UIColor colorWithRed:0.980 green:0.949 blue:0.945 alpha:1.00]

#define COLOR_FFFFFF                                   kRGBColor(255, 255, 255)
#define COLOR_FF8F00                                   kRGBColor(255, 143, 0)
#define COLOR_FE0619                                    [UIColor colorWithRed:0.996 green:0.024 blue:0.098 alpha:1.00]

#define COLOR_F0FAF7                                    [UIColor colorWithRed:0.941 green:0.980 blue:0.969 alpha:1.00]

#define COLOR_FDF4E8                                 kRGBColor(253, 244, 232)

#define COLOR_F5F5F5                                   kRGBColor(245, 245, 245)
#define COLOR_F3F3F3                                    [UIColor colorWithRed:0.953 green:0.953 blue:0.953 alpha:1.00]
#define COLOR_F7F6FC                                   kRGBColor(247, 246, 252)

#define COLOR_F7F7F9                                  kRGBColor(247, 247, 249)

#define COLOR_F8162E                                  kRGBColor(248, 22, 46)
#define COLOR_F83330                                    [UIColor colorWithRed:0.973 green:0.200 blue:0.188 alpha:1.00]

#define COLOR_F84745                                    [UIColor colorWithRed:0.973 green:0.278 blue:0.271 alpha:1.00]

#define COLOR_F2F2F2                                   kRGBColor(242, 242, 242)

#define COLOR_F2B68D                                   kRGBColor(242, 182, 141)

#define COLOR_AFAFC7                                   kRGBColor(175, 175, 199)

#define COLOR_BCBCBC                                   [UIColor colorWithRed:0.737 green:0.737 blue:0.737 alpha:1.00]

#define COLOR_FF0009                                   kRGBColor(255, 0, 9)

#define COLOR_F9ECEC                                    [UIColor colorWithRed:0.976 green:0.925 blue:0.925 alpha:1.00]

#define COLOR_F93330                                        [UIColor colorWithRed:0.976 green:0.200 blue:0.188 alpha:1.00]

#define COLOR_4F66E6                                   [UIColor colorWithRed:0.310 green:0.400 blue:0.902 alpha:1.00]

#define COLOR_3E90FF                                    [UIColor colorWithRed:0.243 green:0.565 blue:1.000 alpha:1.00]







#define COLOR_496FE0                                   [UIColor colorWithRed:0.286 green:0.435 blue:0.878 alpha:1.00]

#define COLOR_54C89B                                    [UIColor colorWithRed:0.329 green:0.784 blue:0.608 alpha:1.00]


#define COLOR_F2F2F2                                   kRGBColor(242, 242, 242)
#define COLOR_F2F2F2                                   kRGBColor(242, 242, 242)
#define COLOR_F2F2F2                                   kRGBColor(242, 242, 242)
#define COLOR_F2F2F2                                   kRGBColor(242, 242, 242)
#define COLOR_F2F2F2                                   kRGBColor(242, 242, 242)
#define COLOR_F2F2F2                                   kRGBColor(242, 242, 242)
#define COLOR_F2F2F2                                   kRGBColor(242, 242, 242)

#define COLOR_5C5C5C                                   kRGBColor(92, 92, 92)
#define COLOR_F86B0D                                   kRGBColor(248, 107, 13)
#define COLOR_FEF2E9                                   kRGBColor(254, 242, 233)
#define COLOR_1B4DD7                                   kRGBColor(27, 77, 215)

#define COLOR_B4C7E7 kRGBColor(180, 199, 231)
#define COLOR_F9BE00 kRGBColor(249, 190, 0)
#define COLOR_FAAF7B kRGBColor(250, 175, 123)
#define COLOR_FD5E4E kRGBColor(253, 94, 78)

#define COLOR_952C1D kRGBColor(149, 44, 29)

#define COLOR_191E33 kRGBColor(25, 30, 51)

#define COLOR_000000 UIColorFromRGB(0X000000)

#define COLOR_F5DA2A UIColorFromRGB(0XF5DA2A)

#define COLOR_979797 UIColorFromRGB(0X979797)
#define COLOR_A2A2A2 UIColorFromRGB(0XA2A2A2)
#define COLOR_F93330 UIColorFromRGB(0XF93330)


#import "UIView+Ex.h"
#import "NSDate+Ex.h"
#import "UIView+SLImage.h"
#import "UIImage+DIYScale.h"

@interface Macro : NSObject
















@end
