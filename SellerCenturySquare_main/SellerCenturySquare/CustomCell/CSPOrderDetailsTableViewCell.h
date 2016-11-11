//
//  CSPOrderDetailsTableViewCell.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"

@interface CSPOrderDetailsTableViewCell : CSPBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *circularView;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalQuantityLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalAmoountLabel;

@property (weak, nonatomic) IBOutlet UIView *orderTypeBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalTotalAmountLabel;



@property (weak, nonatomic) IBOutlet UILabel *consigneeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneePhone;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;

@property (weak, nonatomic) IBOutlet UIImageView *orderImageFirst;

@property (weak, nonatomic) IBOutlet UIImageView *orderImageSecond;

@end
