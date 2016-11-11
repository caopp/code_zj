//
//  MemberTradeDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MemberTradeDTO : BasicDTO

/**
 *  小B编码
 */
@property(nonatomic,copy)NSString *memberNo;
/**
 *  小B名称
 */
@property(nonatomic,copy)NSString *memberName;
/**
 *  小B联系电话
 */
@property(nonatomic,copy)NSString *mobilePhone;
/**
 *  最新交易时间
 */
@property(nonatomic,strong)NSNumber *time;

/**
 *  交易总金额(类型:double)
 */
@property(nonatomic,strong)NSNumber *amount;
/**
 *  平台等级
 */
@property(nonatomic,copy)NSString *tradeLevel;
/**
 *  店铺等级
 */
@property(nonatomic,strong)NSNumber *shopLevel;
/**
 *  JID
 */
@property(nonatomic,strong)NSString *chatAccount;
/**
 *  昵称
 */
@property(nonatomic,strong)NSString *nickName;


@end
