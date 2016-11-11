//
//  StoreTagLisrtModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "StoreTagLisrtModel.h"
#import "StoreTagModel.h"

@implementation StoreTagLisrtModel

- (id)init{
    self = [super init];
    if (self) {
        //进行初始化
        self.storeTagDTOList = [[NSMutableArray alloc]init];
        
        
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
    
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"labelCategory"]]) {
        
            self.labelCategory = [dictInfo objectForKey:@"labelCategory"];
        }
    
        //#数据合法性进行判断
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
            //创建数组
            self.storeTagList = [NSMutableArray array];
            //所得数据进行传递
            self.storeTagDTOList = [dictInfo objectForKey:@"list"];
            //进行forin循环
            for (NSDictionary* storeTagInfoDict in self.storeTagDTOList) {
                
                self.storeTagModel = [[StoreTagModel alloc]initWithDictionary:storeTagInfoDict];
            
                [self.storeTagList addObject:self.storeTagModel];
            }
        }
    
    
    
       
    
    
    
}

@end
