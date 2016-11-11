//
//  DownLoadRecordModel.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/19.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface DownLoadRecordModel : BasicDTO

//购买次数/单价
@property (nonatomic,copy)NSString *digest;
//购买份数
@property (nonatomic,assign)int quantity;
//购买金额
@property (nonatomic,assign)CGFloat  totalAmount;



//采购单号
@property (nonatomic,copy)NSString *orderCode;
//购买时间
@property (nonatomic,copy)NSString *createTime;

////总共次数
@property (nonatomic,assign)NSInteger totalCount;

@end
