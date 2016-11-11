//
//  CPSBuyerDetailInfoViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
@interface CPSBuyerDetailInfoViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *memberNo;
@property (nonatomic,copy) NSString *chatAccount;
@property (nonatomic,copy) NSString *nickName;

@end
