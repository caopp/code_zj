//
//  CSPCartSectionHeaderView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/1/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPCartSectionHeaderView.h"
#import "CartListDTO.h"
#import "WholeSaleConditionDTO.h"

@interface CSPCartSectionHeaderView ()

@end

@implementation CSPCartSectionHeaderView
- (void)awakeFromNib
{
    self.merchantNameButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.style = CartSectionHeaderViewStyleNormal;
    }

    return self;
}


- (void)setStyle:(CartSectionHeaderViewStyle)style {
    if (style == CartSectionHeaderViewStyleNormal) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        self.showDoMeetImage.hidden = YES;
        [self.warningView setHidden:YES];
    } else {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130);
        [self.warningView setHidden:NO];
          self.showDoMeetImage.hidden = NO;
        [self updateWarningByMerchantCondition:self.merchantInfo.condition];
    }

    [self setNeedsLayout];
}

- (void)setupWithMerchantInfo:(CartMerchant *)merchantInfo section:(NSInteger)section {
    self.merchantInfo = merchantInfo;
    
    [self.selectButton setHidden:![merchantInfo isThereGoodsOptional]];

    
  [self.merchantNameButton setTitle:@"" forState:UIControlStateNormal];
    self.merchantNameLabel.text = merchantInfo.merchantName;
    self.merchanName.text = merchantInfo.merchantName;
    

    self.section = section;

    self.selectButton.selected = self.merchantInfo.selected;
}

- (void)updateWarningByMerchantCondition:(SaleMerchantCondition *)merchantCondition {
    if ([merchantCondition.batchNumFlag isEqualToString:@"0"] &&
        [merchantCondition.batchAmountFlag isEqualToString:@"0"]) {

        NSMutableAttributedString* conditionString = [[NSMutableAttributedString alloc]initWithString:@"全店满 件 或满 元 起批" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        NSAttributedString* batchNumValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", (long)merchantCondition.batchNumLimit] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
        NSAttributedString* batchAmountValueString = [[NSAttributedString alloc]initWithString:[CSPUtils stringFromNumber:[NSNumber numberWithFloat:merchantCondition.batchAmountLimit]] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
        [conditionString insertAttributedString:batchAmountValueString atIndex:9];
        [conditionString insertAttributedString:batchNumValueString atIndex:4];

        self.conditionLabel.attributedText = conditionString;

    } else if (![merchantCondition.batchNumFlag isEqualToString:@"0"] &&
               [merchantCondition.batchAmountFlag isEqualToString:@"0"]) {

        NSMutableAttributedString* conditionString = [[NSMutableAttributedString alloc]initWithString:@"全店满 元 起批" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        NSAttributedString* batchAmountValueString = [[NSAttributedString alloc]initWithString:[CSPUtils stringFromNumber:[NSNumber numberWithFloat:merchantCondition.batchAmountLimit]] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
        [conditionString insertAttributedString:batchAmountValueString atIndex:4];

        self.conditionLabel.attributedText = conditionString;
    } else if ([merchantCondition.batchNumFlag isEqualToString:@"0"] &&
               ![merchantCondition.batchAmountFlag isEqualToString:@"0"]) {

        NSMutableAttributedString* conditionString = [[NSMutableAttributedString alloc]initWithString:@"全店满 件 起批" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        NSAttributedString* batchNumValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", (long)merchantCondition.batchNumLimit] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];

        [conditionString insertAttributedString:batchNumValueString atIndex:4];

        self.conditionLabel.attributedText = conditionString;
    } else {
        self.conditionLabel.text = @"";
    }

    NSMutableAttributedString* quantityString = [[NSMutableAttributedString alloc]initWithString:@"本店已选:" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
    NSAttributedString* quantityValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", (long)self.merchantInfo.totalQuantityForSelectedGoods] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
    NSAttributedString* quantitySignString = [[NSAttributedString alloc]initWithString:@"件" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
    [quantityString appendAttributedString:quantityValueString];
    [quantityString appendAttributedString:quantitySignString];

    self.boughtCountLabel.attributedText = quantityString;

    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"小计:" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
    NSAttributedString* priceSignString = [[NSAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];
    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.02f", self.merchantInfo.totalPriceForSelectedGoods] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
    [priceString appendAttributedString:priceSignString];
    [priceString appendAttributedString:priceValueString];
    
    self.totalPriceLabel.attributedText = priceString;

}

- (IBAction)goOnShoppingButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:showMerchantGoods:)]) {
        [self.delegate sectionHeaderView:self showMerchantGoods:self.merchantInfo.merchantNo];
    }
}

- (IBAction)cancelButtonClicked:(id)sender {
    self.merchantInfo.isSatisfy = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:reloadSection:)]) {
        [self.delegate sectionHeaderView:self reloadSection:self.section];
    }
}

- (IBAction)merchantNameButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:showMerchantGoods:)]) {
        [self.delegate sectionHeaderView:self showMerchantGoods:self.merchantInfo.merchantNo];
    }
}

- (IBAction)selectButtonClicked:(id)sender {

    BOOL selectionStatus = !self.selectButton.selected;
    self.selectButton.selected = selectionStatus;
    self.merchantInfo.selected = selectionStatus;

    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:selectionStatusChanged:)]) {
        [self.delegate sectionHeaderView:self selectionStatusChanged:self.selectButton.selected];
    }
}

- (IBAction)enquiryButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:startEnquiryWithMerchantInfo:)]) {
        [self.delegate sectionHeaderView:self startEnquiryWithMerchantInfo:self.merchantInfo];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
