//
//  LookFerightTempListModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "LookFerightTempListModel.h"
#import "LookFerightTempModel.h"
@implementation LookFerightTempListModel

-(id)init
{
    self = [super init];
    if (self) {
        self.lookFerightTempDTOList = [[NSMutableArray alloc]init];
         return  self;
    }else
    {
        return nil;
    }
}


//继承父类方法
-(void)setDictFrom:(NSDictionary *)dictInfo
{
    if (!dictInfo) {
        return;
    }
    
    //选中类型
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
        self.type = [dictInfo objectForKey:@"type"];
    }
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"templateName"]]) {
        self.templateName = [dictInfo objectForKey:@"templateName"];
    }
    
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"data"]]) {
        //创建数组
        self.lookFerightTempList = [NSMutableArray array];
        //传送个数据
        self.lookFerightTempDTOList = [dictInfo objectForKey:@"data"];
        //进行forin循环
        for (NSDictionary *dictionary in self.lookFerightTempDTOList) {
          
            LookFerightTempModel *lookFerightTempModel = [[LookFerightTempModel alloc]initWithDictionary:dictionary];
            [self.lookFerightTempList addObject:lookFerightTempModel];
            
        }
    }
}



@end
