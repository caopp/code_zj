//
//  GoodsMainDTO.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/20.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GoodsMainDTO : BasicDTO

//!在售批发商品数量
@property(nonatomic,strong)NSNumber * wholesaleNum;

//!在售零售商品数量
@property(nonatomic,strong)NSNumber * retailNum;


//!新发布商品数量 注意，此名未与接口文档的字段名对应
@property(nonatomic,strong)NSNumber * newsGoodsNum;

//!待审核的分享商品数量
@property(nonatomic,strong)NSNumber * pendingAuditNum;

//!新增加参考图的商品数量 注意，此名未与接口文档的字段名对应
@property(nonatomic,strong)NSNumber * newsRefPicNum;


@end
