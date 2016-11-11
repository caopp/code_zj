//
//  GetRecommendRecordDetailsListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

// 3.32	推荐商品记录详情接口
#import "BasicDTO.h"

@interface GetRecommendRecordDetailsListDTO : BasicDTO

/**
 *  推荐记录Id(类型 int)
 */
@property(nonatomic,strong)NSNumber *Id;
/**
 *  推荐商品数量(类型 int)
 */
@property(nonatomic,strong)NSNumber *goodsNum;
/**
 *  推荐收件人数(类型 int)
 */
@property(nonatomic,strong)NSNumber *memberNum;
/**
 *  记录创建时间
 */
@property(nonatomic,copy)NSString *createDate;
/**
 *  推荐内容
 */
@property(nonatomic,copy)NSString *content;
/**
 *  商品窗口图列表(GoodsPicDTO)
 */
@property(nonatomic,strong)NSMutableArray *goodsPicDTOList;
/**
 *  收件人列表(RecommendMemberDTO)
 */
@property(nonatomic,strong)NSMutableArray *recommendMemberDTOList;

@end
