//
//  AppInfoDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "AppInfoDTO.h"
#import <UIKit/UIKit.h>

static AppInfoDTO *appInfoDTO = nil;

@implementation AppInfoDTO

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        appInfoDTO = [[self alloc] init];
        
        
        NSLog(@"[UIDevice currentDevice].model = %@",[UIDevice currentDevice].model);
    
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // The device is an iPad running iOS 3.2 or later.
            appInfoDTO.deviceType = @"2";
        }
        else
        {
            // The device is an iPhone or iPod touch.
            
            appInfoDTO.deviceType = @"1";
        }
        
//        if ([[UIDevice currentDevice].model containsString:@"iPhone"]) {
//             appInfoDTO.deviceType = @"1";
//            
//        }else if([[UIDevice currentDevice].model containsString:@"iPad"]){
//            appInfoDTO.deviceType = @"2";
//        }
        
        #if (TARGET_IPHONE_SIMULATOR)
                appInfoDTO.deviceToken = [[UIDevice currentDevice]identifierForVendor].UUIDString;
        #endif
        
        
        appInfoDTO.imei = @"test";
        
        NSString *key=@"CFBundleShortVersionString";
        //加载程序中info.plist文件（获取当前软件的版本号）
        NSString *currentVerionCode=[NSBundle mainBundle].infoDictionary[key];

        appInfoDTO.appVersion = currentVerionCode;
        
        appInfoDTO.iosVersion = [[UIDevice currentDevice] systemVersion];
        
        //加载程序中info.plist文件（获取当前软件的版本号 整型）
        NSString *keyInt = @"CFBundleShortVersionInt";
        NSNumber *currentVerionIntCode=[NSBundle mainBundle].infoDictionary[keyInt];
        appInfoDTO.appVersionInt = currentVerionIntCode?[NSString stringWithFormat:@"%@",currentVerionIntCode]:@"0";
        
        appInfoDTO.appKey = @"123456";
        
        appInfoDTO.appType = @"1";
        
        
        // !大屏
        if ([UIScreen mainScreen].bounds.size.width >=1080) {
            
            appInfoDTO.screenType =@"2";
            
        }else{// !小屏
            
            appInfoDTO.screenType =@"1";
            
        }
        
        
    });
    return appInfoDTO;
}

@end
