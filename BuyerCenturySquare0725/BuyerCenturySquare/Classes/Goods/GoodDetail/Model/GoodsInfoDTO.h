//
//  GoodsInfoDTO.h
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"
#import "GoodsInfoDetailsDTO.h"
#define kGoodsInfoHttpSuccessNotification @"GoodsInfoHttpSuccessNotification"

@interface GoodsInfoDTO : BasicDTO
@property (nonatomic,copy) NSString *goodsNo;
@property (nonatomic,strong)GoodsInfoDetailsDTO *goodsInfoDetailsInfo;
+ (instancetype)sharedInstance;


@end
