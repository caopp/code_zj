//
//  CPSSetBlackListViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CPSSetBlackListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addToBlackListButton;

//大B商家平台等级
@property (nonatomic ,strong) NSNumber *level;
@property (nonatomic ,assign) BOOL isInBlackList;
@property (nonatomic ,copy) NSString *memberName;
@property (nonatomic ,copy) NSString *memberNo;

@end
