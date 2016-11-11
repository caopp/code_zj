//
//  GoodReferenceDTO.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GoodReferenceDTO : BasicDTO

//是否设置窗口参考图：0未设置,1已设置
@property (nonatomic,strong)NSNumber *isSetWPic;
//是否设置详情参考图：0未设置,1已设置
@property (nonatomic,strong)NSNumber *isSetRPic;
//商品编码
@property (nonatomic,strong)NSString *goodsNo;
//商品名称
@property (nonatomic,strong)NSString *goodsName;
//商品图片路径
@property (nonatomic,strong)NSString *imgUrl;
//商品颜色
@property (nonatomic,strong)NSString *color;
//商品货号
@property (nonatomic,strong)NSString *goodsWillNo;
//零售价
@property (nonatomic,strong)NSNumber *retailPrice;
//商品状态：2已上架，3已下架
@property (nonatomic,strong)NSString *goodsStatus;
//图片数量
@property (nonatomic,strong)NSNumber *picNum;
//已设置的窗口图数量
@property (nonatomic,strong)NSNumber *setWNum;
//已设置的参考图数量
@property (nonatomic,strong)NSNumber *setRNum;
//新审核的窗口图数量
@property (nonatomic,strong)NSNumber *wQty;
//新审核的参考图数量
@property (nonatomic,strong)NSNumber *rQty;

@end
