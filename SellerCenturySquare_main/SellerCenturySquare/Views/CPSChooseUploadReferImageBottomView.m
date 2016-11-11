


//
//  CPSChooseUploadReferImageBottomView.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSChooseUploadReferImageBottomView.h"

@implementation CPSChooseUploadReferImageBottomView

- (void)awakeFromNib{
    self.backgroundColor = HEX_COLOR(0xf0f0f0FF);
    self.tipLineView.backgroundColor = HEX_COLOR(0xd2d2d2FF);
    
    [self.selectAllBtn setImage:[UIImage imageNamed:@"04_商家中心_商品_未选中"] forState:UIControlStateNormal];
    
    [self.selectAllBtn setImage:[UIImage imageNamed:@"04_商家中心_商品_选中"] forState:UIControlStateSelected];
    
    
}

- (IBAction)deleteButtonClick:(id)sender {
    self.deleteBlock();
}

- (IBAction)uploadButtonClick:(id)sender {
    self.uploadBlock();
}
//!全选
- (IBAction)selectAllBtn:(id)sender {

    UIButton * allBtn = sender;
    allBtn.selected = !allBtn.selected;
    
    if (self.selectAllBlock) {
        
        self.selectAllBlock(allBtn.selected);
        
        
    }


}

@end
