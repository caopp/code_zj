//
//  CSPShoppingCartTypeCTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMailCartTableViewCell.h"
#import "CartListDTO.h"
#import "CSPAmountControlView.h"
#import "SingleSku.h"
#import "CSPUtils.h"

@interface CSPMailCartTableViewCell () <CSPSkuControlViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation CSPMailCartTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.skuView.delegate = self;
}

- (void)setValid:(BOOL)valid {
    //非已过期商品,将已过期标示右移出Cell
    self.trailingSpaceInvalidLabelConstraint.constant = !valid && !self.isEditing ? kCustomTrailingSpace : -kCustomTrailingSpace * 5;
    _valid = valid;
}
- (void)setDeleteEnable:(BOOL)enable {
    
    [super setDeleteEnable:enable];
    
    self.trailingSpaceInvalidLabelConstraint.constant = !enable && !self.valid ? kCustomTrailingSpace : -kCustomTrailingSpace * 5;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithCartGoodsInfo:(CartGoods *)cartGoodsInfo {
    [super setupWithCartGoodsInfo:cartGoodsInfo];

    [self updateGoodsPriceByCartQuantity];

    self.skuView.skuValue = [self.cartGoods.skuList firstObject];
    self.skuView.batchNumLimit = self.cartGoods.batchNumLimit;
    
    
     [self setValid:!self.cartGoods.isInvalidCartGoods];
//    [self setValid:!self.cartGoods.isInvalidCartGoods];
    if ([cartGoodsInfo.goodsStatus isEqualToString:@"2"]) {
        self.selectButton.hidden = NO;
        self.skuView.hidden = NO;
        
    }else
    {
        self.selectButton.hidden = YES;
        self.skuView.hidden = YES;
        
    }
    

    
    
}




- (void)updateGoodsPriceByCartQuantity {
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

    
    [self layoutIfNeeded];
}

- (void)showLastLine:(BOOL)isHide
{
    self.lineView.hidden = isHide;
    
}

#pragma mark - Delegate
#pragma mark CSPSkuControlViewDelegate
//添加数量

- (void)skuControlView:(CSPSkuControlView*)skuControlView skuValueChanged:(BasicSkuDTO*)skuValue valueType:(NSString *)valueType {
    [self updateGoodsPriceByCartQuantity];

    [self updateCartBySkuDTO:(DoubleSku*)skuValue valueType:valueType];

}

- (BOOL)skuControlView:(CSPSkuControlView*)skuControlView couldSkuValueChanged:(NSInteger)tagetValue {
    NSInteger limitedValue = self.cartGoods.batchNumLimit - [self.cartGoods totalQuantityExceptSku:skuControlView.skuValue];
    if (limitedValue <= tagetValue){
        if (tagetValue ==0&&[self.cartGoods.cartType isEqualToString:@"2"]) {
            return NO;
            
        }
        return YES;
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cartTableViewCellSkuValueCannotSubtract)]) {
            [self.delegate cartTableViewCellSkuValueCannotSubtract];
        }
        return NO;
    }

//    if (self.cartGoods.batchNumLimit <= tagetValue){
//        return YES;
//    } else {
//        return NO;
//    }
}


@end
