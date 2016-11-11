//
//  LoginDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface LoginDTO : BasicDTO

/**
 *  用户登录标识
 */
@property(nonatomic,copy)NSString *tokenId;

/**
 *  小B编码
 */
@property(nonatomic,copy)NSString *memberNo;

/**
 *  1:已注册 2:等待审核 3:审核未通过 4:已通过 5:关闭封号
 */
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *joinType;// 2:在线申请 5地推邀请
@property(nonatomic,copy)NSString *refuseContent;
@property(nonatomic,copy)NSString *isChangeDevice;//	String	是否更换设备登录: 0 是 1否
//是否审核通过后首次登录0是 1否
@property(nonatomic,copy)NSString *loginFlag;
@property(nonatomic, strong)NSString* memberAccount;

+ (instancetype)sharedInstance;

- (NSInteger)convertStatusToInteger;







@end
