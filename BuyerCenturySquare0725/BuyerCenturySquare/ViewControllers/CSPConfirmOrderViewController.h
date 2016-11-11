//
//  CSPConfirmOrderViewController.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CSPConfirmOrderViewController : BaseViewController

@property (nonatomic, strong)NSArray* selectedGoods;

//如果是从采购车进来的设置为YES;
@property (nonatomic ,assign) BOOL isGoods;

@end
