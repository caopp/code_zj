//
//  GoodsMoreDTO.h
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/28.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "BasicDTO.h"
#import "ImgDTO.h"
#import "AttrDTO.h"
@interface GoodsMoreDTO : BasicDTO

@property(nonatomic,strong)NSNumber *goodId;
@property(nonatomic,strong)NSString *goodsNo;	//String	商品编码
@property(nonatomic,strong)NSString *goodsName;	//	String	商品名称
@property(nonatomic,strong)NSString *merchantName;	//	String	商家名称
@property(nonatomic,strong)NSString *merchantNo;	//	String	商家编码
@property(nonatomic,strong)NSString *merchantListPic;	//	String	商家列表图地址
@property(nonatomic,strong)NSString *details;	//	String	商品详情
@property(nonatomic,strong)NSString *color;	//	String	商品颜色
@property(nonatomic,strong)NSNumber *retailPrice;	//	Double	零售价
@property(nonatomic,strong)NSString *goodsStatus;	//	String	2为有效商品，其他为失效商品（0编辑中，1新发布未上架，2已上架，3已下架）
@property(nonatomic,strong)NSString *defaultPicUrl;	//	String	商品列表图
@property(nonatomic,strong)NSString *goodsWillNo;	//	String	货号
@property(nonatomic,strong)NSString *goodsStyle;	//	String	款号
@property(nonatomic,strong)NSArray *windowImageList;	//	list	窗口图
@property(nonatomic,strong)NSArray *window_objectList;	//	list	窗口图 客观图
@property(nonatomic,strong)NSArray *window_referList;	//	list	窗口图 参考图
@property(nonatomic,strong)NSArray *objectiveImageList;//	list	客观图


@property(nonatomic,strong)NSArray *referImageList;//	list	参考图


@property(nonatomic,strong)NSArray *skuList;//	list	sku列表值


@property(nonatomic,strong)NSArray *attrList;//	list	规格参数
@end
