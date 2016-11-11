//
//  MyOrderParentTableViewCell.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MergeSendGoodsDTO.h"
@class MyOrderParentTableViewCell;
@protocol  MyOrderParentDelegate <NSObject>

/**
 *  拍摄快递单发货
 *
 *  @param cell
 *  @param orderList
 */
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




@end

@interface MyOrderParentTableViewCell : UITableViewCell

/**
 *  隐藏bottomViewCell和TopViewCell ,@"top"/@"bottom"
 */
@property (nonatomic ,strong)NSString *hideView;



@property (nonatomic ,strong) OrderListDTO* orderLsitDto;
@property (nonatomic ,strong) MemberListDTO *memberListDto;
@property (nonatomic ,assign) id<MyOrderParentDelegate>delegate;

@end

