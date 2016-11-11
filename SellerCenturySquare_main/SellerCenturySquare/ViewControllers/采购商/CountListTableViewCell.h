//
//  CountListTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetMemberInfoDTO.h"
@interface CountListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *amountL;
@property (weak, nonatomic) IBOutlet UILabel *weekAmountL;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthAmountL;
@property (weak, nonatomic) IBOutlet UILabel *orderNumL;
@property (weak, nonatomic) IBOutlet UILabel *weekOrderNumL;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthOrderNumL;

@property (nonatomic,strong) GetMemberInfoDTO *getMemberInfoDTO;

@end
