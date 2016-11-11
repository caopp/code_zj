//
//  CSPRecommendContactsViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CSPRecommendContactsViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic,strong) NSMutableDictionary *goodsInfoDic;
@property (nonatomic,copy) NSString *dayNum;
@end
