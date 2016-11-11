//
//  CSPMerchantNoGoodsView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//  !商店没有商品的view

#import <UIKit/UIKit.h>

@interface CSPMerchantNoGoodsView : UIView

// !很抱歉
@property (weak, nonatomic) IBOutlet UILabel *sorryLabel;

// !商家暂无上架在售商品
@property (weak, nonatomic) IBOutlet UILabel *noGoodsLabel;


@end
