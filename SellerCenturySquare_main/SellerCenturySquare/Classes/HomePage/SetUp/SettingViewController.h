//
//  SettingViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/12.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
