//
//  AppInfoDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"


@interface AppInfoDTO : BasicDTO
/**
 *  设备类型
 */
@property(nonatomic,copy)NSString *deviceType;

/**
 *  设备号
 */
@property(nonatomic,copy)NSString *deviceToken;

/**
 *  移动设备识别码
 */
@property(nonatomic,copy)NSString *imei;

@property(nonatomic,copy)NSString *appVersion;

@property(nonatomic,copy)NSString *iosVersion;

/**
 *  客户端应用版本号 整型
 */
@property(nonatomic,copy)NSString *appVersionInt;


@property(nonatomic,copy)NSString *appKey;

@property(nonatomic,copy)NSString *appType;

/**
 *  屏幕大小 ,1:大屏  2：小屏
 */

@property(nonatomic,copy)NSString *screenType;



+ (instancetype)sharedInstance;

@end
