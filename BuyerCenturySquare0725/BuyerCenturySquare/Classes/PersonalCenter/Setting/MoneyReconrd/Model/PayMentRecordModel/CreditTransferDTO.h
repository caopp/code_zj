//
//  CreditTransferDTO.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/16.
//  Copyright © 2016年 pactera. All rights reserved.
// !预付货款充值记录查询

#import "BasicDTO.h"

@interface CreditTransferDTO : BasicDTO

//!充值升级等级
@property(nonatomic,copy)NSString *subject;

//!审核状态  0待审核，1暂未到账，2通过，3未通过

@property(nonatomic,copy)NSString *auditStatus;

//!充值金额
@property(nonatomic,assign)double amount;

//!提交审核时间
@property(nonatomic,copy)NSString *createDate;

//!充值方式
@property(nonatomic,copy)NSString *paymethod;

//!审核编码
@property(nonatomic,copy)NSString *auditNo;

//!转账银行名称
@property(nonatomic,copy)NSString *bankName;

//!转出银行卡开户人姓名
@property(nonatomic,copy)NSString *userName;

//!充值等级
@property(nonatomic,copy)NSString *level;

//!银行编码
@property(nonatomic,copy)NSString *bankCode;

//!交易采购单号
@property(nonatomic,copy)NSString *tradeNo;

@end
