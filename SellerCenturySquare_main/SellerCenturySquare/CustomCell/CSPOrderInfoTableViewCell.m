//
//  CSPOrderInfoTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPOrderInfoTableViewCell.h"

@implementation CSPOrderInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self updateSizeLabelsBorder];
}

- (void)updateSizeLabelsBorder {
    
    for (UILabel* sizeLabel in self.sizeLabels) {
        
        sizeLabel.layer.masksToBounds = YES;
        sizeLabel.layer.cornerRadius = 3.0f;
        sizeLabel.layer.borderColor = [UIColor blackColor].CGColor;
        sizeLabel.layer.borderWidth = 0.5;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)modifyOrTakePhoneButtonClick:(id)sender {
    self.modifyOrTakePhoneButtonBlock();
}
- (void)changeView
{
    CGPoint swearTitleViewPoint = self.swearTitleLabel.center;
    swearTitleViewPoint.y = self.swearImageView.center.y;
    self.swearTitleLabel.center = swearTitleViewPoint;
    
}


//商品名称
- (void)setSwearTitleText:(NSString *)swearTitleText
{
    _swearTitleLabel.text = swearTitleText;
}

//颜色
- (void)setColorText:(NSString *)colorText
{
    _colorLabel.text = colorText;
    
}

//所有商品的数量
- (void)setAmountText:(NSString *)amountText
{
    _amountLabel.text = amountText;
}

- (void)setTotalGoodsNumText:(NSString *)totalGoodsNumText
{
    _totalGoodsNumLabel.text = totalGoodsNumText;
    
}


//应支付金额
- (void)setShouldPayText:(NSString *)shouldPayText
{
    
    _shouldPayLabel.textColor = [UIColor blackColor];
    
    NSMutableAttributedString *orderPrice = [[NSMutableAttributedString alloc] initWithString:shouldPayText];
    
    [orderPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,5)];
    [orderPrice addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] range:NSMakeRange(0, 3)];
    _shouldPayLabel.attributedText = orderPrice;
    
}



- (void)setTotalOrderPriceText:(NSString *)totalOrderPriceText
{
    
    _TotalOrderPriceLabel.textColor = [UIColor blackColor];
    
    NSMutableAttributedString *orderPrice = [[NSMutableAttributedString alloc] initWithString:totalOrderPriceText];
    
    
    
    [orderPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,5)];
    [orderPrice addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] range:NSMakeRange(0, 6)];
    _TotalOrderPriceLabel.attributedText = orderPrice;
    
}

//- (void)setTotalOrderPriceLabel:(UILabel *)TotalOrderPriceLabel
//{
//
//
//
//    TotalOrderPriceLabel.textColor = [UIColor blackColor];
//
//    NSMutableAttributedString *orderPrice = [[NSMutableAttributedString alloc] initWithString:TotalOrderPriceLabel.text];
//
//
//
//    [orderPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,5)];
//    [orderPrice addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] range:NSMakeRange(0, 4)];
//    TotalOrderPriceLabel.attributedText = orderPrice;
//
//}

- (void)setPriceText:(NSString *)priceText
{
    NSMutableAttributedString *orderPrice = [[NSMutableAttributedString alloc] initWithString:priceText];
    
    
    [orderPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0,1)];
    _priceLabel.attributedText = orderPrice;
}
//- (void)setPriceLabel:(UILabel *)priceLabel
//{
//
//    NSMutableAttributedString *orderPrice = [[NSMutableAttributedString alloc] initWithString:priceLabel.text];
//
//
//
//    [orderPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0,1)];
//    priceLabel.attributedText = orderPrice;
//}

//- (void)setAllOrderNumLabel:(UILabel *)allOrderNumLabel
//{
//    NSMutableAttributedString *orderPrice = [[NSMutableAttributedString alloc] initWithString:allOrderNumLabel.text];
//
//
//
//    [orderPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(0,1)];
//    allOrderNumLabel.attributedText = orderPrice;
//}

- (void)setAllOrderText:(NSString *)allOrderText
{
    NSMutableAttributedString *orderPrice = [[NSMutableAttributedString alloc] initWithString:allOrderText];
    
    
    
    [orderPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(0,1)];
    _allOrderNumLabel.attributedText = orderPrice;
    
}
- (void)normalView
{
    CGRect  rect = self.swearTitleLabel.frame;
    rect.origin.y = self.swearImageView.frame.origin.y;
    self.swearTitleLabel.frame = rect;
    
}
- (IBAction)selectshootCouriersingleDeliveryBtn:(id)sender {
    self.selectshootCouriersingleDeliveryBtnBlock();
    
}
@end
