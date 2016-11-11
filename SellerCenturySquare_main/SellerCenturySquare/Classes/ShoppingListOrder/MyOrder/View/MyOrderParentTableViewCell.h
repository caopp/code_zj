//
//  MyOrderParentTableViewCell.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MergeSendGoodsDTO.h"
#import "GetOrderDTO.h"
#import "orderGoodsItemDTO.h"
#import "UIImageView+WebCache.h"

@class MyOrderParentTableViewCell;
@protocol  MyOrderParentDelegate <NSObject>

/**
 *  拍摄快递单发货
 *
 *  @param cell
 *  @param orderList
 */
/*****合并拍照*******/

- (void)myOrderParentSelectShootExpressSingle:(MyOrderParentTableViewCell *)cell orderListDto:(OrderListDTO *)orderList;

/**
 *  录入快递单
 *
 *  @param cell
 *  @param orderList
 */
- (void)myOrderParentSelectEntryExpressSingle:(MyOrderParentTableViewCell *)cell orderListDto:(OrderListDTO *)orderList;

/**
 *  全选
 *
 *  @param memberDto 
 */
- (void)myOrderParentSelectMerchantOrder:(MemberListDTO *)memberDto;

/**
 *  单选
 *
 *  @param orderList
 *  @param memberList  
 */
- (void)myOrderParentSelectOrderList:(OrderListDTO *)orderList memberListDto:(MemberListDTO *)memberList;


/**
 *  点击 人名跳转到商家列表
 *
 *  @param memberDto
 */
- (void)myOrderParentSelectMerchantName:(MemberListDTO *)memberDto;

/**
 *  客服
 *
 *  @param memberDto
 */
-(void)myOrderParentSelectSerVice:(MemberListDTO *)memberDto;


/******我的采购单*********/
- (void)myOrderParentSelectShootExpressSingle:(MyOrderParentTableViewCell *)cell getOrderdto:(GetOrderDTO *)getOrderdto;

//采购单／我的采购单客服
-(void)myOrderParentSelectSerViceOrder:(GetOrderDTO *)getOrderDto;


/**
 *  录入快递单
 *
 *  @param cell
 *  @param orderList
 */
- (void)myOrderParentSelectEntryExpressSingle:(MyOrderParentTableViewCell *)cell getOrderdto:(GetOrderDTO *)getOrderdto;
//修改采购单
-(void)myOrderParentChangeOrderPrice:(GetOrderDTO*)getOrderdto cell:(MyOrderParentTableViewCell *)cell;







@end

@interface MyOrderParentTableViewCell : UITableViewCell

/**
 *  隐藏bottomViewCell和TopViewCell ,@"top"/@"bottom"
 */
@property (nonatomic ,strong)NSString *hideView;


//头部和底部model
@property (nonatomic ,strong) GetOrderDTO *orderDto;

//中间不同的商品 样板，邮费，普通
@property (nonatomic ,strong) orderGoodsItemDTO *goodsItemDto;



@property (nonatomic ,strong) OrderListDTO* orderLsitDto;
@property (nonatomic ,strong) MemberListDTO *memberListDto;
@property (nonatomic ,assign) id<MyOrderParentDelegate>delegate;



@end

