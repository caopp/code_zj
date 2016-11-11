//
//  CSPShoppingCartTypeATableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPNormalCartTableViewCell.h"
#import "CartListDTO.h"
#import "CSPAmountControlView.h"
#import "CartUpdateDTO.h"
#import "CSPUtils.h"

@interface CSPNormalCartTableViewCell () <CSPSkuControlViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation CSPNormalCartTableViewCell

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self setValid:YES];
//    }
//
//    return self;
//}

- (void)awakeFromNib {
    // Initialization code
    
    [self.skuViewList enumerateObjectsUsingBlock:^(CSPSkuControlView* obj, NSUInteger idx, BOOL *stop) {
        obj.delegate = self;
    }];
    
    self.futureLabel.font = [UIFont   systemFontOfSize:11];
    self.spotLabel.font = [UIFont   systemFontOfSize:11];
    self.priceLabel.font = [UIFont systemFontOfSize:16];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

- (void)setupWithCartGoodsInfo:(CartGoods *)cartGoodsInfo {
    [super setupWithCartGoodsInfo:cartGoodsInfo];

    // 设置颜色label
    if (!self.cartGoods.isInvalidCartGoods) {
        
        self.colorLabel.text = [NSString stringWithFormat:@"%@  起批: %ld", self.cartGoods.color, self.cartGoods.batchNumLimit];
        
    } else {
        
        self.colorLabel.text = self.cartGoods.color;
    }
    
    

    //设置价格数量
    [self updateGoodsPriceByCartQuantity];

    //添加按钮就的方框
    [self updateSkuViewList];

    [self setValid:!self.cartGoods.isInvalidCartGoods];
    
    [self updateSelectButtonAndRedTip];
//    self. selectButton.hidden = YES;
    if ([cartGoodsInfo.goodsStatus isEqualToString:@"2"]) {
        self.selectButton.hidden = NO;
    }else
    {
        self.selectButton.hidden = YES;
    }
    
    [self setNeedsDisplay];
}

//更改列表显示数量
- (void)updateGoodsPriceByCartQuantity {
    
    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

    CGFloat goodsPrice = self.cartGoods.cartPrice;
    NSString* goodsPriceString = [CSPUtils isRoundNumber:goodsPrice] ? [NSString stringWithFormat:@"%ld", (long)goodsPrice] : [NSString stringWithFormat:@"%.02f", goodsPrice];
    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

    NSAttributedString* markString = [[NSAttributedString alloc]initWithString:@" × " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];

    NSAttributedString* quantityString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", (long)self.cartGoods.cartQuantity] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

    [priceString appendAttributedString:priceValueString];
    [priceString appendAttributedString:markString];
    [priceString appendAttributedString:quantityString];

    self.priceLabel.attributedText = priceString;
}

- (void)updateSkuViewList {
    if (!self.cartGoods.isInvalidCartGoods) {

        //sb上获取所有View
        if (self.skuViewList.count > 0) {
            
            //设置现货期货都不隐藏
            [self.futureLabel setHidden:NO];
            [self.spotLabel setHidden:NO];
            
            //取出所有的期货和现货单
            [self.skuViewList enumerateObjectsUsingBlock:^(CSPSkuControlView* obj, NSUInteger idx, BOOL *stop) {
                
                if (idx < self.cartGoods.skuList.count) {
                    
                    
                    [obj setHidden:NO];
                    //起批数量
                    obj.batchNumLimit = self.cartGoods.batchNumLimit;
                    obj.delegate = self;
                    
                    
                    //赋值单个sku的model
                    obj.totalNumb = self.cartGoods.totalNumb;

//                    obj.cartGoods = self.cartGoods;
                    obj.skuValue = self.cartGoods.skuList[idx];
                    
                    
                } else {
                    //隐藏视图
                    [obj setHidden:YES];
                }
                idx < self.cartGoods.skuList.count ? [obj setHidden:NO]: [obj setHidden:YES];
            }];

        } else {
            //隐藏所有视图
            [self.futureLabel setHidden:YES];
            [self.spotLabel setHidden:YES];

            [self.skuViewList enumerateObjectsUsingBlock:^(CSPSkuControlView* obj, NSUInteger idx, BOOL *stop) {
                [obj setHidden:YES];
            }];
        }

    } else {
        [self.futureLabel setHidden:YES];
        [self.spotLabel setHidden:YES];

        [self.skuViewList enumerateObjectsUsingBlock:^(CSPSkuControlView* obj, NSUInteger idx, BOOL *stop) {
            [obj setHidden:YES];
        }];
    }
}




#pragma mark -CSPSkuControlViewDelegate
-(void)skuControlView:(CSPSkuControlView *)skuControlView couldSkuAddCount:(NSString *)numb
{
    self.cartGoods.totalNumb = numb;

    for (DoubleSku *doubleDto in self.cartGoods.skuList) {
        NSLog(@"%ld~%ld",(long)doubleDto.spotValue,(long)doubleDto.futureValue );
    }
    
    
    //取出所有的期货和现货单
    [self.skuViewList enumerateObjectsUsingBlock:^(CSPSkuControlView* obj, NSUInteger idx, BOOL *stop) {
        
        if (idx < self.cartGoods.skuList.count) {
            
            
            [obj setHidden:NO];
            //起批数量
            obj.batchNumLimit = self.cartGoods.batchNumLimit;
//            obj.delegate = self;
            
            
            //赋值单个sku的model
            obj.totalNumb = self.cartGoods.totalNumb;
            
            //                    obj.cartGoods = self.cartGoods;
            obj.skuValue = self.cartGoods.skuList[idx];
            [obj changeBasicSkuDTO:self.cartGoods.skuList[idx]];
            
            
            
        } else {
            //隐藏视图
            [obj setHidden:YES];
        }
        idx < self.cartGoods.skuList.count ? [obj setHidden:NO]: [obj setHidden:YES];
    }];
    
}


- (void)skuControlView:(CSPSkuControlView*)skuControlView skuValueChanged:(BasicSkuDTO*)skuValue valueType:(NSString *)valueType {
    DoubleSku *sku =(DoubleSku*)skuValue;
    
    
    DebugLog(@"DoubleSku = %lu %lu",sku.spotValue,sku.futureValue);

    //更新购物车
    [self updateCartBySkuDTO:(DoubleSku*)skuValue valueType:valueType];
    
    //更改列表显示数量
    [self updateGoodsPriceByCartQuantity];
    
    [self updateSelectButtonAndRedTip];
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(cartTableViewCellSkuValueChanged)]) {
        [self.delegate cartTableViewCellSkuValueChanged];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cartTableViewCell:cartTableViewCellSkuValueChangedToValid:)]) {
        [self.delegate cartTableViewCell:self cartTableViewCellSkuValueChangedToValid:[self.cartGoods isValidCartGoods]];
    }
    
}



- (void)updateSelectButtonAndRedTip {
    if ([self.cartGoods isCartQuantityLessThanBatchNumLimit]) {
        [self.selectButton setHidden:YES];
        [self.redTipLabel setHidden:NO];
    } else {
        [self.selectButton setHidden:NO];
        [self.redTipLabel setHidden:YES];
    }
}

- (BOOL)skuControlView:(CSPSkuControlView*)skuControlView couldSkuValueChanged:(NSInteger)tagetValue {
    NSInteger limitedValue = self.cartGoods.batchNumLimit - [self.cartGoods totalQuantityExceptSku:skuControlView.skuValue];
    
    if (limitedValue <= tagetValue){
        return YES;
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cartTableViewCellSkuValueCannotSubtract)]) {
            [self.delegate cartTableViewCellSkuValueCannotSubtract];
        }
        
        return NO;
    }
}

- (void)showLastLine:(BOOL)isHide
{
    self.lineView.hidden = isHide;
    
}

@end
