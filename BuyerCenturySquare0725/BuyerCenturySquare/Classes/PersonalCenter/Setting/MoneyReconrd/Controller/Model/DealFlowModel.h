//
//  DealFlowModel.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/19.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface DealFlowModel : BasicDTO
//充值升级等级
@property (nonatomic,copy)NSString *subject;
//充值金额
@property (nonatomic,assign)double amount;
//充值时间
@property (nonatomic,copy)NSString *createTime;

//总共次数
@property (nonatomic,assign)NSInteger totalCount;
@end
