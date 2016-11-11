//
//  BottomSendGoodsAccoutsMeessagCellTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderParentTableViewCell.h"
//待发货

@interface BottomSendGoodsAccoutsMeessagCellTableViewCell : MyOrderParentTableViewCell
/**
 *  商品所有数量
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalNumbLab;
/**
 *  商品实付/应付价格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPayPrice;
//订单总价
@property (weak, nonatomic) IBOutlet UILabel *orderTotalPriceLab;

//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderStateLab;

//!显示价格类型：0，采购单总价 1.订单总价
@property (weak, nonatomic) IBOutlet UILabel *showTotalPriceTypeLab;
@property (nonatomic ,strong) GetOrderDTO *recrodGetOrderDto;

//拍摄快递单发货
@property (weak, nonatomic) IBOutlet UIButton *photoExpressOrderBtn;

- (IBAction)selectPhotoExpressOrderBtn:(id)sender;


//录入快递单发货
@property (weak, nonatomic) IBOutlet UIButton *entryExpressOrderBtn;

- (IBAction)selectEntryExpressOrderBtn:(id)sender;

@end
