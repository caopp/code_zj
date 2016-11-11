//
//  MerchantDeatilNavView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/2.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MerchantDeatilNavView.h"

@implementation MerchantDeatilNavView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    [self.collectBtn setImage:[UIImage imageNamed:@"merchant_collect"] forState:UIControlStateNormal];
    
    [self.collectBtn setImage:[UIImage imageNamed:@"merchant_collectSelected"] forState:UIControlStateSelected];
    

}

//!返回按钮
- (IBAction)backBtnClick:(id)sender {

    if (self.backBlock) {
        
        self.backBlock();
        
    }
    
}

//!店铺介绍 按钮
- (IBAction)merhantIntroduceBtnClick:(id)sender {
    
    if (self.merchantIntroduceBlock) {
        
        self.merchantIntroduceBlock();
        
    }
    
}


//!商品分类
- (IBAction)merchantCategoryBtnClick:(id)sender {
    
    if (self.merchantCategoryBlock) {
        
        self.merchantCategoryBlock();
        
    }
    
}
//!邮费专拍
- (IBAction)postPageBtnClick:(id)sender {
    
    if (self.postageBlock) {
        
        self.postageBlock();
        
    }
    
    
}
//!客服按钮
- (IBAction)serviceBtnClick:(id)sender {
    
    if (self.serviceBtnBlock) {
        
        self.serviceBtnBlock();
        
    }
    
}

//!收藏
- (IBAction)collectBtnClick:(id)sender {
    
    
    if (self.collectBtnBlock) {
        
        self.collectBtnBlock();
        
    }
    
    
}


@end
