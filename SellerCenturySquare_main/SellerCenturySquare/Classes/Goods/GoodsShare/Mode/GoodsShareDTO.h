//
//  GoodsShareDTO.h
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"
#import "GoodsSharePicDTO.h"
typedef NS_ENUM(NSInteger, GoodsShareStatus) {
    AllShareStatus = 0,//全部
    UnShareStatus = 1,//未审核
    PassShareStatus = 2,//通过
    RejectShareStatus//未通过
};
@interface GoodsShareDTO : BasicDTO
@property(nonatomic,strong)NSNumber *labelId	;//int	分享标签id
@property(nonatomic,strong)NSNumber *userId	;//Int	会员id
@property(nonatomic,strong)NSString *userName;//	String	会员名称
@property(nonatomic,strong)NSString *iconUrl;//String	会员头像
@property(nonatomic,strong)NSNumber *wPicNum;//int	窗口图数量
@property(nonatomic,strong)NSNumber *rPicNum;//int	参考图数量
@property(nonatomic,strong)NSNumber *status;//	int	提成审核状态(1:未审核,2:通过,3:不通过)
@property(nonatomic,strong)NSString *goodsNo;//String	商品编码
@property(nonatomic,strong)NSString *goodsName;//String	商品名称
@property(nonatomic,strong)NSString *imgUrl;//String	商品图片路径
@property(nonatomic,strong)NSString *color;//String	商品颜色
@property(nonatomic,strong)NSString *goodsWillNo;//	String	商品货号
@property(nonatomic,strong)NSNumber *retailPrice;//	double	零售价
@property(nonatomic,strong)NSNumber *isComm;//int	是否可以提成(0:无,1:有)
@property(nonatomic,strong)NSNumber *commPercent;//	double	提成百分比
@property(nonatomic,strong)NSString *createDate;//	String	提交时间

@property (nonatomic,strong)NSNumber *userType;//会员类型(0-普通会员、1-演员)
@property(nonatomic,strong)NSString *auditDate;  //	String	审核时间
@property(nonatomic,strong)NSArray * picList;//		图片list GoodsPicDTO

@property(nonatomic,strong)NSArray *windownList;
@property(nonatomic,strong)NSArray *referenceList;

@property (nonatomic,strong)NSNumber *sharedGoodsNum;//sharedGoodsNum	int	分享商品次数
@property (nonatomic,strong)NSNumber *shareNum; //	int	分享次数
@property (nonatomic,strong)NSNumber *auditPassNum; //	int	审核通过次数

@property(nonatomic,strong)NSNumber *totalCount;
@end
