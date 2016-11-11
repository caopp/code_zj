//
//  OrderDeliveryDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-27.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface OrderDeliveryDTO : BasicDTO

/**
 *  采购单编号
 */
@property(nonatomic,copy)NSString *orderCode;

/**
 *  快递单图片地址
 */
//@property(nonatomic,copy)NSString *deliveryReceiptImage;
/**
 *  创建时间
 */
@property(nonatomic,copy)NSString *createTime;



/**
 *  快递单图片地址
 */
@property (nonatomic ,strong) NSString *deliveryReceiptImage;


/**
 *  发货类型：1.拍照发货 2.快递单发货
 */
@property (nonatomic ,strong) NSNumber *type;

/**
 *  快递公司代码
 */
@property (nonatomic ,strong) NSString *logisticCode;

/**
 *  快递单号
 */
@property (nonatomic ,strong) NSString *logisticTrackNo;

/**
 *  快递公司名称
 */
@property (nonatomic ,strong) NSString *logisticName;



@end
