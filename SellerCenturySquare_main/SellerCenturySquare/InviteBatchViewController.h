//
//  InviteBatchViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  通讯录--？设置等级

#import "BaseViewController.h"
#import "GetMerchantNotAuthTipDTO.h"
@interface InviteBatchViewController : BaseViewController

@property (nonatomic,strong) NSArray *contactsInfo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) GetMerchantNotAuthTipDTO *getMerchantNotAuthTipDTO;
@property (weak, nonatomic) IBOutlet UILabel *hasNoAuthL;
@property (weak, nonatomic) IBOutlet UIView *hasNoAuthView;


@end
