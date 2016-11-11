//
//  GetEditGoodsListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetEditGoodsListDTO.h"

@implementation GetEditGoodsListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.EditGoodsDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {
                
                self.totalCount = [dictInfo objectForKey:@"totalCount"];
            }
            //        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodslist"]]) {
            //
            //            self.EditGoodsDTOList = [dictInfo objectForKey:@"goodslist"];
            //        }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end
