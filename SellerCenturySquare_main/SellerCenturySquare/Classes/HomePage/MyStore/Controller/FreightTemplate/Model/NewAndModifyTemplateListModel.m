//
//  NewAndModifyTemplateListModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "NewAndModifyTemplateListModel.h"
#import "NewAndModifyTemplateModel.h"
@implementation NewAndModifyTemplateListModel
-(id)init
{
    self = [super init];
    if (self) {
        self.setList = [[NSMutableArray alloc]init];
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
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"templateName"]]) {
        self.templateName = [dictInfo objectForKey:@"templateName"];
    }
    
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
        self.type = [dictInfo objectForKey:@"type"];
    }
    
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"setList"]]) {
               //进行forin循环
        for (NSDictionary *dictionary in self.setList) {
            
            NewAndModifyTemplateModel *newAndModifyTemplateModel = [[NewAndModifyTemplateModel alloc]initWithDictionary:dictionary];
            
            [self.setList addObject:newAndModifyTemplateModel];
            
        }
    }
}



@end
