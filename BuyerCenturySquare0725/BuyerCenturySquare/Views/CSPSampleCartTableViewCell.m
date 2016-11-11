//
//  CSPShoppintCartTypeBTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPSampleCartTableViewCell.h"
#import "CartListDTO.h"
#import "CSPUtils.h"

@interface CSPSampleCartTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *sampleLab;


@end
@implementation CSPSampleCartTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.sampleLab.layer.borderWidth = 0.5f;
    self.sampleLab.layer.borderColor = [UIColor blackColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValid:(BOOL)valid {
    //非已过期商品,将已过期标示右移出Cell
    self.trailingSpaceInvalidLabelConstraint.constant = !valid ? kCustomTrailingSpace : -kCustomTrailingSpace * 5;
    _valid = valid;
}

- (void)setDeleteEnable:(BOOL)enable {

    [super setDeleteEnable:enable];

    self.trailingSpaceInvalidLabelConstraint.constant = !enable && !self.valid ? kCustomTrailingSpace : -kCustomTrailingSpace * 5;
    
}

- (void)setupWithCartGoodsInfo:(CartGoods *)cartGoodsInfo {
    [super setupWithCartGoodsInfo:cartGoodsInfo];

    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

    CGFloat goodsPrice = self.cartGoods.cartPrice;
    NSString* goodsPriceString = [CSPUtils isRoundNumber:goodsPrice] ? [NSString stringWithFormat:@"%ld", (long)goodsPrice] : [NSString stringWithFormat:@"%.02f", goodsPrice];

    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

    NSAttributedString* markString = [[NSAttributedString alloc]initWithString:@" × " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];

    NSAttributedString* quantityString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", self.cartGoods.cartQuantity] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

    [priceString appendAttributedString:priceValueString];
    [priceString appendAttributedString:markString];
    [priceString appendAttributedString:quantityString];

    self.priceLabel.attributedText = priceString;

    [self setValid:!self.cartGoods.isInvalidCartGoods];
    if ([cartGoodsInfo.goodsStatus isEqualToString:@"2"]) {
        self.selectButton.hidden = NO;
    }else
    {
         self.selectButton.hidden = YES;
    }

    [self layoutIfNeeded];
}

- (void)showLastLine:(BOOL)isHide
{
    self.lineView.hidden = isHide;
    
}
@end

