//
//  SearchMerhantDTO.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/25.
//  Copyright © 2016年 pactera. All rights reserved.
//!搜索出的商家结果

#import "BasicDTO.h"

@interface SearchMerhantDTO : BasicDTO


//!商家编码
@property(nonatomic,copy)NSString * merchantNo;

//!商家名称
@property(nonatomic,copy)NSString * merchantName;

//!档口号
@property(nonatomic,copy)NSString * stallNo;

//!标签名称
@property(nonatomic,copy)NSString * labelName;

//!分类名称
@property(nonatomic,copy)NSString * categoryName;

//!商品数量
@property(nonatomic,strong)NSNumber * goodsNum;

//!商家图片列表
@property(nonatomic,copy)NSString  * pictureUrl;

//!是否搜索 0是 1否
@property(nonatomic,copy)NSString  * isFavorite;

//!商家下面要查看的10个商品
@property(nonatomic,strong)NSMutableArray * tenNumGoodsArray;


@end


//!商家下面要显示的10个商品
@interface TenNumGoodsDTO : BasicDTO

//!商品图片url
@property(nonatomic,copy)NSString * imgUrl;

//!可查看等级
@property(nonatomic,strong)NSNumber * readLevel;

//!会员价
@property(nonatomic,strong)NSNumber * memberPirce;

//!商品编码
@property(nonatomic,copy)NSString * goodsNo;

//!权限标识(0:无 1:有)
@property(nonatomic,copy)NSString * authFlag;



@end

