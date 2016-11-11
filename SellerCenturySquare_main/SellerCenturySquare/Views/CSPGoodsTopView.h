//
//  CSPGoodsTopView.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"
#import "EditGoodsDTO.h"

@interface CSPGoodsTopView : CSPBaseCustomView
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (weak, nonatomic) IBOutlet UILabel *articleNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *filterLabelOne;

@property (weak, nonatomic) IBOutlet UILabel *filterLabelTwo;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterOneHight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterTwoHight;


@property (copy,nonatomic)void(^selectedGoods)();

@end
