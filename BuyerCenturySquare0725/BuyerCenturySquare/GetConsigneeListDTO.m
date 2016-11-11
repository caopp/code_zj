//
//  GetConsigneeListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetConsigneeListDTO.h"
#import "ConsigneeDTO.h"

@implementation GetConsigneeListDTO

- (id)init{
    self = [super init];
    if (self) {
        //进行初始化
        self.consigneeDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

//继承父类的方法
- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        //#数据合法性进行判断
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"data"]]) {
            //创建数组
            self.consigneeList = [NSMutableArray array];
            //所得数据进行传递
            self.consigneeDTOList = [dictInfo objectForKey:@"data"];
            //进行forin循环
            for (NSDictionary* consigneeInfoDict in self.consigneeDTOList) {
                //对收货地址进行
                ConsigneeDTO* consigneeInfo = [[ConsigneeDTO alloc]initWithDictionary:consigneeInfoDict];
                //添加数组中
                [self.consigneeList addObject:consigneeInfo];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    

}

- (ConsigneeDTO*)defaultConsignee {

    for (ConsigneeDTO* consignee in self.consigneeList) {
        if ([consignee.defaultFlag isEqualToString:@"0"]) {
            return consignee;
        }
    }
    
    return [self.consigneeList firstObject];
}

@end
