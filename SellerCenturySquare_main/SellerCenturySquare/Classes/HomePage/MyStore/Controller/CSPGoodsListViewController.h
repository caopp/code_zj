//
//  CSPGoodsViewController.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, CSPMerchantStyle) {
    CSPMerchantStyleNormal,
    CSPMerchantStyleClosed,         //关闭
    CSPMerchantStyleBlackList,      //黑名单
    CSPMerchantStyleOutOfBusiness,  //歇业
};

@interface CSPGoodsListViewController :BaseViewController

@end
