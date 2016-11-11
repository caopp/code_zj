//
//  GoodsInfoDTO.m
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GoodsInfoDTO.h"

@implementation GoodsInfoDTO

static GoodsInfoDTO *goodsInfoDTO = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        goodsInfoDTO = [[self alloc] init];
    });
    return goodsInfoDTO;
    
}

- (void)setGoodsInfoDetailsInfo:(GoodsInfoDetailsDTO *)goodsInfoDetailsInfo{
    
    _goodsInfoDetailsInfo = goodsInfoDetailsInfo;
    [[NSNotificationCenter defaultCenter]postNotificationName:kGoodsInfoHttpSuccessNotification object:nil];
    
    
}
@end
