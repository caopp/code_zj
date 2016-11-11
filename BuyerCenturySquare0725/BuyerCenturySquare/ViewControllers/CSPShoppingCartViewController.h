//
//  CSPShoppingCartViewController.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CSPShoppingCartViewController : BaseViewController

@property (nonatomic ,assign) BOOL isBlockUp;

//!如果是从 我的-》采购车进入的时候，这个值为yes
@property(nonatomic,assign)BOOL fromPersonCenterShopCart;



@end
