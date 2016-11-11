
//  GetShopGoodsListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetShopGoodsListDTO.h"
#import "ShopGoodsDTO.h"
@implementation GetShopGoodsListDTO

- (id)init{
    
    self = [super init];
    if (self) {
        self.ShopGoodsDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
    
}


-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"operateStatus"]]) {
                
                self.operateStatus = [dictInfo objectForKey:@"operateStatus"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {
                
                self.totalCount = [dictInfo objectForKey:@"totalCount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"closeEndTime"]]) {
                
                self.closeEndTime = [dictInfo objectForKey:@"closeEndTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"closeStartTime"]]) {
                
                self.closeStartTime = [dictInfo objectForKey:@"closeStartTime"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodslist"]]) {
                
                NSMutableArray *arr = [dictInfo objectForKey:@"goodslist"];
                
                NSMutableArray *shopList = [[NSMutableArray alloc]init];
                
                for(NSDictionary *shopGoodsDic in arr){
                    
                    ShopGoodsDTO *shopGoodsDTO = [[ShopGoodsDTO alloc ]init];
                    [shopGoodsDTO setDictFrom:shopGoodsDic];
                    
                    [shopList addObject:shopGoodsDTO];
                }
                
                self.ShopGoodsDTOList = shopList;
            }
            NSLog(@"%@\n",self.ShopGoodsDTOList);
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    

}
@end
