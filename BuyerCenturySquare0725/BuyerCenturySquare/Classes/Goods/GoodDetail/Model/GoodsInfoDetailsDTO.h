//
//  GoodsInfoDetailsDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"
#import "DoubleSku.h"
#import "AttrListDTO.h"
@interface GoodsInfoDetailsDTO : BasicDTO
/**
 *  商品名称
 */
@property(nonatomic,copy)NSString *goodsName;

/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;

/**
 *  商品货号
 */
@property(nonatomic,copy)NSString *goodsWillNo;
/**
 *  商品状态
 */
@property(nonatomic,copy)NSString *goodsStatus;


/**
 *  商家名称
 */
@property(nonatomic,copy)NSString *merchantName;

/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;

/**
 *  商品详情(暂时未使用)
 */
@property(nonatomic,copy)NSString *details;

/**
 *  商品颜色
 */
@property(nonatomic,copy)NSString *color;

/**
 *  商品类别名称
 */
@property(nonatomic,copy)NSString *categoryName;

/**
 *  品牌名称
 */
@property(nonatomic,copy)NSString *brandName;

/**
 *  商品价格
 */
@property(nonatomic,strong)NSNumber *price;

/**
 *  样板价
 */
@property(nonatomic,strong)NSNumber *samplePrice;

/**
 *  上架时间
 */
@property(nonatomic,copy)NSString *onSaleTime;

/**
 *  下架时间
 */
@property(nonatomic,copy)NSString *offSaleTime;

/**
 *  是否已收藏(0已收藏1未收藏)
 */
@property(nonatomic,copy)NSString *isFavorite;

/**
 *  0普通商品、1邮费专拍
 */
@property(nonatomic,copy)NSString *goodsType;

/**
 *  起批数量(类型：int)
 */
@property(nonatomic,strong)NSNumber *batchNumLimit;
/**
 *  选购数量(类型：int)
 */
@property(nonatomic,assign)NSInteger buyNum;
/**
 *  选购样本(类型：int)
 */
@property(nonatomic,assign)NSInteger buyMode;

/**
 *  店铺混批金额限制（-1为不限制）(类型：int)
 */
@property(nonatomic,strong)NSNumber *shopBatchAmountLimit;

/**
 *  店铺混批数量限制（-1为不限制）(类型：int)
 */
@property(nonatomic,strong)NSNumber *shopBatchNumLimit;

/**
 *  商品收藏权限(0:无1:有)
 */
@property(nonatomic,copy)NSString *goodsCollectAuth;

/**
 *  窗口图查看权限(0:无1:有)
 */
@property(nonatomic,copy)NSString *windowPicViewAuth;

/**
 *  客观图查看权限(0:无1:有)
 */
@property(nonatomic,copy)NSString *detailPicViewAuth;

/**
 *  参考图查看权限(0:无1:有)
 */
@property(nonatomic,copy)NSString *referPicViewAuth;

/**
 *  图片下载权限(0:无1:有)
 */
@property(nonatomic,copy)NSString *downloadAuth;

/**
 *  分享权限(0:无1:有)
 */
@property(nonatomic,copy)NSString *shareAuth;

/**
 *  混批条件描述
 */
@property(nonatomic,copy)NSString *batchMsg;
/**
 *  商品列表图
 */
@property(nonatomic,copy)NSString *defaultPicUrl;

/**
 * 样板sku结构体
 */
@property(nonatomic,strong)NSDictionary *sampleSkuInfo;

/**
 *  阶梯价格数组,包含了StepListDTO对象
 */
@property(nonatomic,strong)NSMutableArray *stepList;

/**
 *  窗口图 图片列表,包含了ImageListDTO对象
 */
@property(nonatomic,strong)NSMutableArray *windowImageList;
/**
 *  客观图 图片列表,包含了ImageListDTO对象
 */
@property(nonatomic,strong)NSMutableArray *objectiveImageList;
/**
 *  参考图 图片列表,包含了ImageListDTO对象
 */
@property(nonatomic,strong)NSMutableArray *referImageList;

/**
 *Int	Int	会员的商家等级
 */
@property(nonatomic,copy)NSNumber *shopLevel;
/**
 *  规格参数列表值,包含了AttrListDTO对象
 */
@property(nonatomic,strong)NSMutableArray *attrList;
/**
 *  sku列表值,包含了SkuListDTO对象
 */
@property(nonatomic,strong)NSMutableArray *skuList;

@property(nonatomic,strong)NSMutableArray *exchangedSkuList;

/**
 *  3.67 接口获取
 *  JID数据
 */
@property (nonatomic,strong)NSString *JID;

- (NSMutableArray*)skuDictionaryList;
- (NSInteger)totalQuantity;

- (CGFloat)totalAmount;

@end
