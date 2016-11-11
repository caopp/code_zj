//
//  PicsDownloadViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface PicsDownloadViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *hasDownloadButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadingButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

//完成状态bottom
@property (weak, nonatomic) IBOutlet UILabel *leaveL;
@property (weak, nonatomic) IBOutlet UILabel *leaveNumL;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

//编辑状态bottom
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UILabel *selectAllL;
@property (weak, nonatomic) IBOutlet UIButton *downloadAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;




@end
