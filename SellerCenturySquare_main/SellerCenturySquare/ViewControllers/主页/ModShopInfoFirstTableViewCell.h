//
//  ModShopInfoFirstTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateMerchantInfoModel.h"
@interface ModShopInfoFirstTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameL;
@property (nonatomic,assign) BOOL isMan;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womenButton;
@property (nonatomic,strong) UpdateMerchantInfoModel *updateMerchantInfoModel;

@end
