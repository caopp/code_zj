//
//  TransactionRecordsModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/11/21.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "TransactionRecordsModel.h"

@implementation TransactionRecordsModel
//检查代码的合法性
- (void)setDictFrom:(NSDictionary *)dictInfo
{
    if (self && dictInfo) {
        
        //购买次数合和/单价
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"digest"]]) {
            self.digest = [dictInfo objectForKey:@"digest"];
        }
        //采购单号码
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCode"]]) {
            
            self.orderCode = [dictInfo objectForKey:@"orderCode"];
        }
        //购买时间
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"createTime"]]) {
            
            self.createTime = [dictInfo objectForKey:@"createTime"];
        }
    }
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}

@end
