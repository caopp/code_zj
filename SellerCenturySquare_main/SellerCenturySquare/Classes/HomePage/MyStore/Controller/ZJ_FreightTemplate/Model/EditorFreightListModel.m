//
//  EditorFreightListModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/22.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "EditorFreightListModel.h"
#import "EditorFreightModel.h"
@implementation EditorFreightListModel
- (id)init{
    self = [super init];
    if (self) {
        //进行初始化
        self.freightTempDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

//继承父类的方法
- (void)setDictFrom:(NSDictionary *)dictInfo {
    
    if (!dictInfo) {
        return;
    }
    
    //#数据合法性进行判断
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"data"]]) {
        //创建数组
        self.freightTempList = [NSMutableArray array];
        //所得数据进行传递
        self.freightTempDTOList = [dictInfo objectForKey:@"data"];
        //进行forin循环
        for (NSDictionary* consigneeInfoDict in self.freightTempDTOList) {
            //对iofo地址进行
            EditorFreightModel* freightTempInfo = [[EditorFreightModel alloc]initWithDictionary:consigneeInfoDict];
            //添加数组中
            [self.freightTempList addObject:freightTempInfo];
        }
    }
}


@end
