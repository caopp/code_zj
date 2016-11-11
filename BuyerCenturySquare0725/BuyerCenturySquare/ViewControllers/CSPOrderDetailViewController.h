//
//  CSPOrderDetailViewController.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/15/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol CSPOrderDetailDelegate <NSObject>

- (void)refreshOrder;


@end

@interface CSPOrderDetailViewController : BaseViewController

@property (nonatomic, strong)NSString* orderCode;

@end


