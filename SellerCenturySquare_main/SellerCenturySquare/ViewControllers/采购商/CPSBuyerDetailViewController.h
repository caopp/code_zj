//
//  CPSBuyerDetailViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CPSBuyerDetailViewController : BaseViewController
@property (nonatomic,strong) id memberDTO;
@property (nonatomic,assign) BOOL isInBlackList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
