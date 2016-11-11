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
 *  设备类型 1：iPhone 2：iPad

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

/**
 *  客户端应用版本号
 */
@property(nonatomic,copy)NSString *appVersion;

/**
 *  客户端应用版本号 整型
 */
@property(nonatomic,copy)NSString *appVersionInt;

/**
 *  iOS版本号
 */
@property(nonatomic,copy)NSString *iosVersion;

/**
 *  服务端分配的 目前为@"123456"
 */
@property(nonatomic,copy)NSString *appKey;

/**
 *  客户端类型,1:大B 2:小B
 */
@property(nonatomic,copy)NSString *appType;

/**
 *  屏幕大小 ,1:大屏  2：小屏
 */

@property(nonatomic,copy)NSString *screenType;




+ (instancetype)sharedInstance;
@end
