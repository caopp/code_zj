//
//  DetailWaitCommitBottomView.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "DetailWaitCommitBottomView.h"

@implementation DetailWaitCommitBottomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //!拍照发货按钮的边框
    self.takePhotoBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.takePhotoBtn.layer.borderWidth = 1;
    
    
}



//!录入快递单发货
- (IBAction)takeExpressSendGoods:(id)sender {

    if (self.takeExpressSendBlock) {
        
        self.takeExpressSendBlock();
    }
    
    
}

//!拍照发货
- (IBAction)takePhotoSendGoods:(id)sender {
    
    if (self.takePhotoSenedBlock) {
        
        self.takePhotoSenedBlock();
        
    }

    
}






@end
