//
//  CPSMyOrderViewController.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, MenuBar) {
    MenuALLOrder = 0,
    MenuWaitPayOrder,
    MenuWaitDeliverGoodsOrder,
    MenuWaitGoodsReceiptOrder,
    MenuCompletionOrder,
    MenuCancelOrderRefresh,
    MenuDealOrderRefresh
};


@interface CPSMyOrderViewController : BaseViewController

@property(nonatomic,assign)MenuBar menuBar;

@end
