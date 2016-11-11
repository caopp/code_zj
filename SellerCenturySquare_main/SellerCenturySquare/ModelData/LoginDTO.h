//
//  LoginDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
// 3.1	登陆接口

#import "BasicDTO.h"

@interface LoginDTO : BasicDTO

/**
 *  商家帐号
 */
@property(nonatomic,copy)NSString *merchantNo;
/**
 * 用户登录标识(相当于Session)
 */
@property(nonatomic,copy)NSString *tokenId;
/**
 * 商家账户
 */
@property(nonatomic,copy)NSString *merchantAccount;
@property(nonatomic,copy)NSString *isChangeDevice;//	String	是否更换设备登录: 0 是 1否

/**
 * 是否第一次登录(0:是，1：否)
 */
@property(nonatomic,copy)NSString *firstLogin;

+ (instancetype)sharedInstance;

- (BOOL)loginParameterIsLack;

@end
