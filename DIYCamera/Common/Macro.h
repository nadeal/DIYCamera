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


//rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define THEME_COLOR            kRGBColor(92, 130, 240)

#define CHECK_TXT_PURPLE              kRGBColor(79, 102, 230)

#pragma mark 颜色设置






#import "UIView+Ex.h"
#import "NSDate+Ex.h"
#import "UIView+SLImage.h"
#import "UIImage+DIYScale.h"

@interface Macro : NSObject
















@end
