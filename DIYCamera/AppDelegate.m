//
//  AppDelegate.m
//  DIYCamera
//
//  Created by Billy on 2021/8/14.
//

#import "AppDelegate.h"
#import "Macro.h"
#import "FileDirTools.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.allowRotation = 0;
    [self onCreatePhotoDirMethod:@"999"];
    return YES;
}

-(void) onCreatePhotoDirMethod:(NSString*) uid {
    NSString *documentStr = [FileDirTools documentsDir];
    self.photoPath = [NSString stringWithFormat:@"%@/%@%@", documentStr, uid, APP_PHOTOS_DIR];
    LogOut(@"photo Path %@", self.photoPath);
    BOOL isSuccess = [FileDirTools createDirectoryAtPath:self.photoPath];
    if (isSuccess) {
        LogOut(@"文件夹创建成功");
    } else {
        LogOut(@"文件夹创建失败");
    }
    
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return self.allowRotation ? UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    return self.allowRotation ? YES : NO;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
