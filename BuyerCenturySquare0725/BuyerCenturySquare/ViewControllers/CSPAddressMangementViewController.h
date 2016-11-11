//
//  CSPAdressMangementViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BaseViewController.h"

@protocol CSPAddressMangementViewControllerDelegate <NSObject>

- (void)updateConsignee:(ConsigneeDTO*)consignee;

@end


@interface CSPAddressMangementViewController : BaseViewController

@property (nonatomic, assign)id<CSPAddressMangementViewControllerDelegate> delegate;


//!是否是从"确认订单"进入
@property(nonatomic,assign)BOOL isFromSureOrder;

//!确认订单界面 选择的id
@property(nonatomic,strong)NSNumber * orderSelectID;


@end
