//
//  GetGoodsInfoListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
//  3.14	大B商品详情接口
#import "BasicDTO.h"

@interface GetGoodsInfoListDTO : BasicDTO
/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;
/**
 *  商家名称
 */
@property(nonatomic,copy)NSString *merchantName;
/**
 *  商品名称
 */
@property(nonatomic,copy)NSString *goodsName;
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;
/**
 *  商品详情
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
 *  品牌编码
 */
@property(nonatomic,copy)NSString *brandNo;

/**
 *  运费模板ID
 */
@property(nonatomic,strong)NSString *ftTemplateId;



/**
 *  商品价格(Double 类型)
 */
@property(nonatomic,strong)NSNumber *price;
/**
 *  上架时间
 */
@property(nonatomic,copy)NSString *onSaleTime;
/**
 *  下架时间
 */
@property(nonatomic,copy)NSString *offSaleTime;

/**
 *  是否有样板价(1有、2无)
 */
@property(nonatomic,copy)NSString *sampleFlag;

/**
 *  样板价(Double 类型)
 */
@property(nonatomic,strong)NSNumber *samplePrice;

/**
 *  商品类型 0普通商品、1邮费专拍
 */
@property(nonatomic,copy)NSString *goodsType;

/**
 *  起批数量
 */
@property(nonatomic,strong)NSNumber *batchNumLimit;

/**
 *  商品列表图
 */
@property(nonatomic,copy)NSString *defaultPicUrl;

/**
 *  商品状态  1:新发布  2:在售  3:下架
 */
@property(nonatomic,strong)NSNumber *goodsStatus;

/**
 *  混批条件描述
 */
@property(nonatomic,copy)NSString *batchMsg;

/**
 *重量(单位kg)
 */
@property(nonatomic,strong)NSNumber * goodsWeight;


/**
 窗口图 图片列表,包含了ImageListDTO对象
 
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
 *  skuList列表(SkuDTO)
 */
@property(nonatomic,strong)NSMutableArray *skuDTOList;
/**
 *  stepList列表(StepDTO)
 */
@property(nonatomic,strong)NSMutableArray *stepDTOList;
/**
 *  规格参数列表值,包含了AttrListDTO对象
 */
@property(nonatomic,strong)NSMutableArray *attrList;

/**
 *会员价列表,包含会员价钱的DTO
 */
@property(nonatomic,strong)NSMutableArray *vipPriceList;

/**
 * 会员价格
 */
@property(nonatomic,strong)NSNumber *price1;
@property(nonatomic,strong)NSNumber *price2;
@property(nonatomic,strong)NSNumber *price3;
@property(nonatomic,strong)NSNumber *price4;
@property(nonatomic,strong)NSNumber *price5;
@property(nonatomic,strong)NSNumber *price6;


/**p
 *  图片下载权限0:无权限1:有权限
 */
@property(nonatomic,copy)NSString *downloadAuth;

@property(nonatomic,assign,readonly)BOOL IsLackParameter;


/*
 商品销售渠道 0 批发 1零售 逗号分割 例如 0,1
 */
@property(nonatomic,copy)NSString * channelList;

//!销售渠道字符串分割的数组
@property(nonatomic,strong)NSMutableArray * channelComponArray;


/*
 零售价
 */
@property(nonatomic,strong)NSNumber * retailPrice;

/*
 是否包邮：0不包邮,1包邮
 */
@property(nonatomic,strong)NSNumber * freeDelivery;



//@property (nonatomic,copy)void (^referImageBlock)(NSMutableArray *referImageArray);
//
//@property (nonatomic,copy)void (^objectiveImageBlock)(NSMutableArray *objectiveImageArray);
//
//@property (nonatomic,copy)void (^windowImageBlock)(NSMutableArray *windowImageArray);


/**
 *  获取窗口图片url
 *
 *  @param windowImage 包含PicDTO
 *
 *  @return 返回获取窗口图片url
 */
- (NSMutableArray *)getWindowImage:(NSMutableArray *)windowImage;

/**
 *  获取客观图url
 *
 *  @param objectiveImage 包含PicDTO
 *
 *  @return 返回客观图url
 */
- (NSMutableArray *)getObjectiveImage:(NSMutableArray *)objectiveImage;

/**
 *  获取参考图url
 *
 *  @param ReferImage 包含PicDTO
 *
 *  @return 返回参考图url
 */
- (NSMutableArray *)getReferImage:(NSMutableArray *)ReferImage;


@end

//!VIP价钱的DTO
@interface VIPPriceDTO : BasicDTO

/**
 *ID
 */
@property(nonatomic,strong)NSNumber *ids;

/**
 *会员等级
 */
@property(nonatomic,strong)NSNumber *level;

/**
 *会员价
 */
@property(nonatomic,strong)NSNumber * amount;


@end

