//
//  GoodsMainDTO.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/20.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsMainDTO.h"

@implementation GoodsMainDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{

    if (self && dictInfo) {
        
        self.wholesaleNum = dictInfo[@"wholesaleNum"];
        
        self.retailNum = dictInfo[@"retailNum"];
        
        self.newsGoodsNum = dictInfo[@"newGoodsNum"];
        
        self.pendingAuditNum = dictInfo[@"pendingAuditNum"];
        
        self.newsRefPicNum = dictInfo[@"newRefPicNum"];
        
    }

}

@end
