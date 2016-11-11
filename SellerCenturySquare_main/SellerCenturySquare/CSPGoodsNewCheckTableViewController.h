//
//  CSPGoodsNewCheckTableViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

typedef NS_ENUM(NSUInteger, CSPService){
    
    CSPOnlineNewsCheck = 1,
    CSPOnlineGoodsCollection= 2,
    CSPOnlineGoodsShare = 3,
    CSPOnlineGoodsPictureLook = 4,
    CSPOnlineGoodsPictureFree = 5,
    CSPOnlineGoodsPicturePay = 6,
    CSPOfflineAdviseSupplier = 7,
    CSPOfflineGuidance = 8,
    CSPOfflineBuyerAdvise = 9,
    
};

@interface CSPGoodsNewCheckTableViewController : BaseTableViewController

@property (nonatomic,assign)CSPService Service;

@end
