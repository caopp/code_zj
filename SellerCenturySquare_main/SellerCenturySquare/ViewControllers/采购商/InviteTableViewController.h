//
//  InviteTableViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/21.
//  Copyright (c) 2015年 pactera. All rights reserved.
// !邀请

#import "BaseTableViewController.h"
#import "GetMerchantNotAuthTipDTO.h"
@interface InviteTableViewController : BaseTableViewController

@property (weak, nonatomic) IBOutlet UITextField *onlyPhoneNum;
@property (nonatomic,strong) GetMerchantNotAuthTipDTO *getMerchantNotAuthTipDTO;

@end
