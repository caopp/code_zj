//
//  ModShopDetailInfoTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/15.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateMerchantInfoModel.h"
@interface ModShopDetailInfoTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,copy) NSString *defaultText;
@property (nonatomic ,strong) UpdateMerchantInfoModel *updateMerchantInfoModel;
@end
