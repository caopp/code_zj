//
//  CourierListModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CourierListModel.h"
#import "CourierModel.h"

@implementation CourierListModel

-(id)init
{
    self = [super init];
    if (self) {
        self.courierListDTOList = [[NSMutableArray alloc]init];
    }
    return self;
}

//继承父类的方法
- (void)setDictFrom:(NSDictionary *)dictInfo {
    
    if (!dictInfo) {
        return;
    }
    

    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"callBack"]]) {
        self.callBack = [dictInfo objectForKey:@"callBack"];
    }
   
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"createDate"]]) {
        self.createDate = [dictInfo objectForKey:@"createDate"];
    }
    //物流运单号
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"logisticCode"]]) {
        self.logisticCode = [dictInfo objectForKey:@"logisticCode"];
    }
    //快递公司编码
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shipperCode"]]) {
        self.shipperCode = [dictInfo objectForKey:@"shipperCode"];
    }
    //物流状态: 2-在途中，3-签收,4-问题件
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"state"]]) {
        self.state = [dictInfo objectForKey:@"state"];
    }

    


    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"traces"]]) {
        //创建数组
        self.courierListDTOList = [NSMutableArray array];
        //传送个数据
        self.courierListDTOList = [dictInfo objectForKey:@"traces"];
        //进行forin循环
        for (NSDictionary *dictionary in self.courierListDTOList) {
            
            CourierModel *courierModel = [[CourierModel alloc]initWithDictionary:dictionary];
            
            [self.courierListDTOList addObject:courierModel];
            
        }
    }

    
    
    
    

    
    
    

}



@end
