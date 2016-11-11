//
//  ModShopInfoNormalTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZAreaPickerView.h"
#import "HZLocation.h"
#import "UpdateMerchantInfoModel.h"

@interface ModShopInfoNormalTableViewCell : UITableViewCell<HZAreaPickerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *contentT;
@property (nonatomic,strong) HZAreaPickerView* locatePicker;
@property (nonatomic,strong) HZLocation* location;
@property (nonatomic,strong) UpdateMerchantInfoModel *updateMerchantInfoModel;
@property (nonatomic,assign) NSInteger index;

- (void)setPicker:(BOOL)set;

// !把身份证验证错误的信息传过去
@property(nonatomic,copy) void(^errorBlock)(NSString *);


@end
