//
//  ModShopInfoViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  修改商家资料

#import "BaseViewController.h"
#import "UpdateMerchantInfoModel.h"

@interface ModShopInfoViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UpdateMerchantInfoModel *updateMerchantInfoModel;

@end
