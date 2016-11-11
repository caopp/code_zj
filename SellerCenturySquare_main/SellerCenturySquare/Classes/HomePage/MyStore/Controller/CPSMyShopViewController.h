//
//  CPSMyShopViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/4.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GetMerchantNotAuthTipDTO.h"
#import "GetMerchantInfoDTO.h"
#import "BaseViewController.h"


@interface CPSMyShopViewController : BaseViewController<UIPickerViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) GetMerchantInfoDTO *getMerchantInfoDTO;
@property (nonatomic,strong) GetMerchantNotAuthTipDTO *getMerchantNotAuthTipDTO;
// !歇业
@property (weak, nonatomic) IBOutlet UIButton *closeShopButton;

// !歇业按钮的背景view
@property (weak, nonatomic) IBOutlet UIView *closeBtnBgView;


@end
