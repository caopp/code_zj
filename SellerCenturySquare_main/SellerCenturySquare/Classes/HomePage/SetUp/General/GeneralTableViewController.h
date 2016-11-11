//
//  GeneralTableViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseTableViewController.h"

@interface GeneralTableViewController : BaseTableViewController

@property (weak, nonatomic) IBOutlet UILabel *appVersionL;
@property (weak, nonatomic) IBOutlet UILabel *versionMsgL;

// !通用的tableView
@property (strong, nonatomic) IBOutlet UITableView *generalTableView;

@end
