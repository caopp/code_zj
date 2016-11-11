//
//  PhotoAndCamerSelectView.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/1/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PhotoAndCamerSelectView.h"
#import "UIColor+HexColor.h"

@implementation PhotoAndCamerSelectView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //!改变位置，让相机 相册之间的距离 和离两边的距离相同
    float distance = (self.frame.size.width - self.photoBtn.frame.size.width - self.camerBtn.frame.size.width)/3.0;
    
    self.photoLeading.constant = distance;
    self.camerTrailing.constant = distance;
    
    //!改变颜色
    [self.photoLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    
    [self.camerLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    

    
}

//!相册
- (IBAction)photoBtnClick:(id)sender {

    if (self.photoBlock) {
        
        self.photoBlock();
        
    }


}



//!相机

- (IBAction)camerBtnClick:(id)sender {
    
    if (self.camerBlock) {
        
        self.camerBlock();
    }
}


@end
