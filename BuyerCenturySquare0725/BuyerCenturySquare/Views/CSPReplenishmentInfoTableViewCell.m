//
//  CSPReplenishmentInfoTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPReplenishmentInfoTableViewCell.h"
#import "RestockedDTO.h"
#import "UIImageView+WebCache.h"
#import "ReplenishmentByMerchantDTO.h"
#import "CSPUtils.h"

@interface CSPReplenishmentInfoTableViewCell () <CSPSkuControlViewDelegate>

@property (nonatomic, strong)ReplenishmentGoods* goodsInfo;

@end

@implementation CSPReplenishmentInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.skuViewList enumerateObjectsUsingBlock:^(CSPSkuControlView* obj, NSUInteger idx, BOOL *stop) {
        obj.delegate = self;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhotoImagetop:)];
    [self.goodsImageView addGestureRecognizer:tap];
    self.goodsImageView.userInteractionEnabled = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)clickPhotoImagetop:(UITapGestureRecognizer *)tap
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(replenishmentclickPhotoImageCell:)]) {
        [self.delegate replenishmentclickPhotoImageCell:self];
        
    }
}

- (IBAction)selectButtonClicked:(id)sender {
    // [self setSelected:YES animated:YES];
    self.goodsInfo.selected = !self.selectButton.selected;
    self.selectButton.selected = self.goodsInfo.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(replenishmentCell:selectionStateChanged:)]) {
        [self.delegate replenishmentCell:self selectionStateChanged:self.selectButton.selected];
    }
}

- (IBAction)enquiryButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(replenishmentCell:enquiryForGoodsInfo:)]) {
        [self.delegate replenishmentCell:self enquiryForGoodsInfo:self.goodsInfo];
    }
}

- (void)setupWithMerchantOrderForReplenishmentInfo:(ReplenishmentGoods *)replenishmentGoodsInfo {
    
    [self setupWithReplenishmentGoodsInfo:replenishmentGoodsInfo];
}

- (void)setupWithTimeOrderForReplenishmentInfo:(ReplenishmentGoods *)replenishmentGoodsInfo {

    [self setupWithReplenishmentGoodsInfo:replenishmentGoodsInfo];
}




- (void)setupWithReplenishmentGoodsInfo:(ReplenishmentGoods *)replenishmentGoodsInfo {
    self.goodsInfo = replenishmentGoodsInfo;

    NSString *goodsMessage = [NSString stringWithFormat:@"%@  起批: %ld", self.goodsInfo.color, self.goodsInfo.batchNumLimit];

    self.titleLabel.text = self.goodsInfo.goodsName;
    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsMessage attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    
    self.descriptionLabel.attributedText = priceValueString;
    
//    self.descriptionLabel.text = [NSString stringWithFormat:@"%@  起批: %ld", self.goodsInfo.color, self.goodsInfo.batchNumLimit];

    NSInteger totalCount = 0;
    for (ReplenishmentSku* sku in self.goodsInfo.skuList) {
        totalCount += sku.value;
    }
    [self setPriceValue:self.goodsInfo.batchPrice totalCount:totalCount];

    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.goodsInfo.pictureUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];

    [self.skuViewList enumerateObjectsUsingBlock:^(CSPSkuControlView* obj, NSUInteger idx, BOOL *stop) {
        if (idx < self.goodsInfo.skuList.count) {
            [obj setHidden:NO];

            obj.skuValue = self.goodsInfo.skuList[idx];
        } else {
            [obj setHidden:YES];
        }
        idx < self.goodsInfo.skuList.count ? [obj setHidden:NO]: [obj setHidden:YES];
    }];

    self.selectButton.selected = self.goodsInfo.selected;
}

//显示采购单价格
- (void)setPriceValue:(CGFloat)price totalCount:(NSInteger)totalCount {
    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

    NSString* goodsPriceString = [CSPUtils isRoundNumber:price] ? [NSString stringWithFormat:@"%ld x %ld", (long)price, totalCount] : [NSString stringWithFormat:@"%.02f x %ld", price, totalCount];

    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:16]}];
    [priceString appendAttributedString:priceValueString];
    self.priceLabel.attributedText = priceString;
}


#pragma mark -
#pragma mark CSPSkuControlViewDelegate


//改变采购单量
- (void)skuControlView:(CSPSkuControlView*)skuControlView skuValueChanged:(BasicSkuDTO*)skuValue {

    NSInteger totalCount = 0;

    for (ReplenishmentSku* sku in self.goodsInfo.skuList) {
        totalCount += sku.value;
    }
    
    [self setPriceValue:[self.goodsInfo stepPriceForCurrentQuantity] totalCount:totalCount];

    if (self.delegate && [self.delegate respondsToSelector:@selector(replenishmentCell:skuViewListValueChanged:)]) {
        [self.delegate replenishmentCell:self skuViewListValueChanged:self.goodsInfo.skuList];
    }
}

- (BOOL)skuControlView:(CSPSkuControlView *)skuControlView couldSkuValueChanged:(NSInteger)tagetValue {
    NSInteger limitedValue = self.goodsInfo.batchNumLimit - [self.goodsInfo totalQuantityExceptSku:(ReplenishmentSku*)skuControlView.skuValue];
    if (limitedValue <= tagetValue){
        return YES;
    } else {
        return NO;
    }
}

@end
