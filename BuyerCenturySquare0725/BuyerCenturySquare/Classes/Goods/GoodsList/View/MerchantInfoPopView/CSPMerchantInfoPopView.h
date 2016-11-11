//
//  CSPMerchantInfoPopView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/24/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//  !商家详情view

#import <UIKit/UIKit.h>
@class MerchantShopDetailDTO;

@interface CSPMerchantInfoPopView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *recordNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
// !档口号的宽高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordNoWidth;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordNumHight;

- (void)setupWithDictionary:(NSDictionary*)dictionary;

//!重构后采用的方法
- (void)setupWithShopDto:(MerchantShopDetailDTO*)merchantShopDetail;


@end
