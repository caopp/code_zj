//
//  GoodsSellDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-10-19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GoodsSellDTO : BasicDTO

//商品编码
@property(nonatomic,copy) NSString* goodsNo;
//窗口图路径
@property(nonatomic,copy)NSString *picUrl;
//销量
@property(nonatomic,strong)NSNumber* sellCount;
//排名
@property(nonatomic,strong)NSNumber* sort;


@end
