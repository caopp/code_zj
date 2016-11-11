//
//  CPSResetBuyerLevelViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CPSResetBuyerLevelViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *modLevelButton;
@property (nonatomic ,strong) NSString *memberNo;
@property (nonatomic ,strong) NSString *memberName;
@property (nonatomic ,strong) NSNumber *shopLevel;
@property (nonatomic ,strong) NSNumber *tradeLevel;

//大B商家平台等级
@property (nonatomic ,strong) NSNumber *level;
@end
