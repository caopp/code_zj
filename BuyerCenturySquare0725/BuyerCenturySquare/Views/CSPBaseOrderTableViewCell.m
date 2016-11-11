//
//  CSPConfirmOrderBaseTypeTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPBaseOrderTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CartListConfirmDTO.h"
#import "OrderGroupListDTO.h"
#import "OrderDetailDTO.h"
#import "CSPUtils.h"

@implementation CSPBaseOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCartGoodsInfo:(CartConfirmGoods *)cartGoodsInfo {
    _cartGoodsInfo = cartGoodsInfo;

    //image
//    if ([_orderGoodsInfo.pictureUrl isEqualToString:@""] || _orderGoodsInfo.pictureUrl == nil) {
//        self.smartImageView.image = [UIImage imageNamed:@"邮费专拍小图"];
//        
//    }else{
        [self.smartImageView sd_setImageWithURL:[NSURL URLWithString:_cartGoodsInfo.pictureUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
//    }
    //goodsName
    self.goodsNameLabel.text = _cartGoodsInfo.goodsName;
    //样板颜色
    self.sampleColorLab.text = _cartGoodsInfo.color;
    

    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

    CGFloat goodsPrice = _cartGoodsInfo.price;
    NSString* goodsPriceString = [CSPUtils isRoundNumber:goodsPrice] ? [NSString stringWithFormat:@"%ld", (long)goodsPrice] : [NSString stringWithFormat:@"%.02f", goodsPrice];

    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]}];

    [priceString appendAttributedString:priceValueString];

    self.priceLabel.attributedText = priceString;

    NSMutableAttributedString* amountString = [[NSMutableAttributedString alloc]initWithString:@" × " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];

    NSAttributedString* amountValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", (long)_cartGoodsInfo.quantity] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]}];

    [amountString appendAttributedString:amountValueString];
    

    self.quantityLabel.attributedText = amountString;
}

- (void)setOrderGoodsInfo:(OrderGoods *)orderGoodsInfo {
    _orderGoodsInfo = orderGoodsInfo;

    //image
//    if ([_orderGoodsInfo.pictureUrl isEqualToString:@""] || _orderGoodsInfo.pictureUrl == nil) {
//        self.smartImageView.image = [UIImage imageNamed:@"邮费专拍小图"];
//        
//    }else{
          [self.smartImageView sd_setImageWithURL:[NSURL URLWithString:_orderGoodsInfo.pictureUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
//    }


    //goodsName
    self.goodsNameLabel.text = _orderGoodsInfo.goodsName;

    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

    CGFloat goodsPrice = _orderGoodsInfo.price;
    NSString* goodsPriceString = [CSPUtils isRoundNumber:goodsPrice] ? [NSString stringWithFormat:@"%ld", (long)goodsPrice] : [NSString stringWithFormat:@"%.02f", goodsPrice];

    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]}];

    [priceString appendAttributedString:priceValueString];

    self.priceLabel.attributedText = priceString;

    NSMutableAttributedString* amountString = [[NSMutableAttributedString alloc]initWithString:@" × " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];

    NSAttributedString* amountValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", (long)_orderGoodsInfo.quantity] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]}];

    [amountString appendAttributedString:amountValueString];

    self.quantityLabel.attributedText = amountString;
}

- (void)setOrderGoodsItemInfo:(OrderGoodsItem *)orderGoodsItemInfo {
    _orderGoodsItemInfo = orderGoodsItemInfo;
    //image
//    if ([_orderGoodsInfo.pictureUrl isEqualToString:@""] || _orderGoodsInfo.pictureUrl == nil) {
//        self.smartImageView.image = [UIImage imageNamed:@"邮费专拍小图"];
//        
//    }else{
        [self.smartImageView sd_setImageWithURL:[NSURL URLWithString:_orderGoodsItemInfo.picUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
//    }

    //goodsName
    self.goodsNameLabel.text = _orderGoodsItemInfo.goodsName;

    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

    CGFloat goodsPrice = _orderGoodsItemInfo.price;
    NSString* goodsPriceString = [CSPUtils isRoundNumber:goodsPrice] ? [NSString stringWithFormat:@"%ld", (long)goodsPrice] : [NSString stringWithFormat:@"%.02f", goodsPrice];

    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]}];

    [priceString appendAttributedString:priceValueString];

    self.priceLabel.attributedText = priceString;

    NSMutableAttributedString* amountString = [[NSMutableAttributedString alloc]initWithString:@" × " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];

    NSAttributedString* amountValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", (long)_orderGoodsItemInfo.quantity] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]}];

    [amountString appendAttributedString:amountValueString];

    self.quantityLabel.attributedText = amountString;
}


+ (CGFloat)cellHeightWithSizesCount:(NSInteger)sizesCount {
    NSInteger lineCount = sizesCount / 2 + sizesCount % 2;
    if (lineCount > 1) {
        return 90.0f + (lineCount - 1)* 19.0f;
    } else {
        return 90.0f;
    }
}

@end
