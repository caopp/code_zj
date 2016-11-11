//
//  CSPReplenishmentInfoTableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"
#import "CSPAmountControlView.h"

@class RestockedDTO;
@class CSPReplenishmentInfoTableViewCell;
@class ReplenishmentGoods;


@protocol CSPReplenishmentInfoTableViewCellDelegate <NSObject>

@optional

- (void)replenishmentCell:(CSPReplenishmentInfoTableViewCell *)replenishmentCell selectionStateChanged:(BOOL)selected;

- (void)replenishmentCell:(CSPReplenishmentInfoTableViewCell*)replenishmentCell skuViewListValueChanged:(NSArray*)skuViewList;

- (void)replenishmentCell:(CSPReplenishmentInfoTableViewCell*)replenishmentCell enquiryForGoodsInfo:(ReplenishmentGoods *)goodsInfo;

- (void)replenishmentclickPhotoImageCell:(CSPReplenishmentInfoTableViewCell *)replenishmentCell;



@end

@interface CSPReplenishmentInfoTableViewCell : CSPBaseTableViewCell

@property (assign, nonatomic) id<CSPReplenishmentInfoTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutletCollection(CSPSkuControlView) NSArray *skuViewList;



- (void)setupWithMerchantOrderForReplenishmentInfo:(ReplenishmentGoods *)replenishmentGoodsInfo;

- (void)setupWithTimeOrderForReplenishmentInfo:(ReplenishmentGoods *)replenishmentGoodsInfo;

@end
