//
//  InviteContactsViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/24.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  邀请通讯录联系人

#import <UIKit/UIKit.h>
#import "GetMerchantNotAuthTipDTO.h"
#import "BaseViewController.h"

@interface InviteContactsViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *selectedL;

@property (weak, nonatomic) IBOutlet UIButton *setLevelButton;

@property (nonatomic,strong) GetMerchantNotAuthTipDTO *getMerchantNotAuthTipDTO;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// !无权限提示view
@property (weak, nonatomic) IBOutlet UIView *noticeView;

@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;



@end
