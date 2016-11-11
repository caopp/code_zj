//
//  CSPGoodsTopView.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsTopView.h"
#import "UIColor+HexColor.h"
@implementation CSPGoodsTopView

- (void)awakeFromNib{
    
    self.articleNumberLabel.textColor = HEX_COLOR(0x666666FF);
    self.typeLabel.textColor = [UIColor colorWithHex:0xfd4f57];
    
    //!分割线颜色
    [self.filterLabelOne setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];
    
    [self.filterLabelTwo setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];
    
    self.filterOneHight.constant = 0.5;
    self.filterTwoHight.constant = 0.5;
  
    

}

- (IBAction)selectedButtonClick:(id)sender {
    
    self.selectedButton.selected = !self.selectedButton.selected;
    
    self.selectedGoods();
}
@end
