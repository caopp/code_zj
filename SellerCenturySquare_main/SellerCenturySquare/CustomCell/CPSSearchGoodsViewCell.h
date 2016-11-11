//
//  CPSSearchGoodsViewCell.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "CSPCustomLabel.h"
#import "EditGoodsDTO.h"

@interface CPSSearchGoodsViewCell : CSPBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet CSPCustomLabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPlaceLabel;

//!价格view
@property (weak, nonatomic) IBOutlet UIView *priceView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceViewHight;


@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

//!销售类型
@property (weak, nonatomic) IBOutlet UILabel *saleTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *wholesaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *retailLabel;


//!第一次上架时间
@property (weak, nonatomic) IBOutlet UILabel *firstSaleTimeLabel;


-(void)configData:(EditGoodsDTO *)editDTO;



@end
