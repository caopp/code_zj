//
//  EditGoodsModel.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface EditGoodsModel : BasicDTO
/**
 *  1新发布,2在售, 3下架（默认在售）不传则是全部
 */
@property(nonatomic,copy)NSString* goodsStatus;
/**
 *  当前页码(默认1,类型:int)
 */
@property(nonatomic,strong)NSNumber* pageNo;

/**
 *  每页显示数量(默认20条,类型:int)
 */
@property(nonatomic,strong)NSNumber *pageSize;

/**
 *  查询条件类型0货号，1商品名称
 */
@property(nonatomic,copy)NSString *queryType;

/**
 *  查询条件输入的 查询值
 */
@property(nonatomic,copy)NSString *param;

/**
 *销售渠道 -1 全部 0 批发 1 零售 2批发和零售 ;默认 0
 */
@property(nonatomic,strong)NSNumber * channelType;


@property(nonatomic,assign,readonly)BOOL IsLackParameter;



@end
