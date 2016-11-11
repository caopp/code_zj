//
//  ShopInfoIntroduceTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateMerchantInfoModel.h"
@interface ShopInfoIntroduceTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *introduceTV;
@property (nonatomic,strong) UpdateMerchantInfoModel *updateMerchantInfoModel;

@end
