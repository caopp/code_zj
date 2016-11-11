//
//  BankPaymentListDTO.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface BankPaymentListDTO : BasicDTO

@property (nonatomic ,strong) NSMutableArray *bankAccList;

@property (nonatomic ,strong) NSMutableArray *prepayBankList;


@end

@interface BankAccListDTO : BasicDTO
//帐号
@property (nonatomic ,copy) NSString *account;
//开户名
@property (nonatomic ,copy) NSString *accountName;
//银行名称
@property (nonatomic ,copy) NSString *bankName;
//银行图片
@property (nonatomic ,copy) NSString *bankPic;
//id
@property (nonatomic ,strong) NSNumber *id;


@end

@interface PrepayBankListDTO : BasicDTO
//银行编码
@property (nonatomic ,strong) NSString *bankCode;
//银行名称
@property (nonatomic ,strong) NSString *bankName;


@end