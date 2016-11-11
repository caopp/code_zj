//
//  TransactionRecordsModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/11/21.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface TransactionRecordsModel : BasicDTO
//购买次数/单价
@property (nonatomic,copy)NSString *digest;
//购买份数
@property (nonatomic,assign)int quantity;
//购买金额
@property (nonatomic,assign)double totalAmount;
//采购单号
@property (nonatomic,copy)NSString *orderCode;
//购买时间
@property (nonatomic,copy)NSString *createTime;
//总共次数
@property (nonatomic,assign)int totalCount;
@end
