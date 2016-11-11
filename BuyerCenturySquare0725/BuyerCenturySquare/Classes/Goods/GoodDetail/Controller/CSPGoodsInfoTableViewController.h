//
//  CSPGoodsInfoTableViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/7/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLMainTableViewController.h"
#import "BaseTableViewController.h"
#import "BaseViewController.h"
#import "MBProgressHUD.h"

@class Commodity;
//滑动状态的类型

@interface CSPGoodsInfoTableViewController : BaseViewController

@property (nonatomic, strong)NSString* goodsNo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopConstraint;

@end
