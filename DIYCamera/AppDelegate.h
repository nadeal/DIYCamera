//
//  AppDelegate.h
//  DIYCamera
//
//  Created by Billy on 2021/8/14.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/**是否允许横屏*/
@property (nonatomic, assign) BOOL allowRotation;

@property (nonatomic, strong) NSString *photoPath;
@property (nonatomic, strong) NSString *PHOTO_TEMP_DIR;//临时文件夹路径



@end

