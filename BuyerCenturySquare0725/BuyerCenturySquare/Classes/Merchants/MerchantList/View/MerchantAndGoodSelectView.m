//
//  MerchantAndGoodSelectView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MerchantAndGoodSelectView.h"

@implementation MerchantAndGoodSelectView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self.firstRightLabel setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    
    [self.firstBtn setBackgroundColor:[UIColor whiteColor]];
    
    [self.secondBtn setBackgroundColor:[UIColor whiteColor]];
    
    self.secondBtn.layer.borderColor = [UIColor colorWithHexValue:0xf0f0f0 alpha:1].CGColor;
    self.secondBtn.layer.borderWidth = 1;
    
    self.secondBtn.hidden = YES;
    

}
-(void)setDataisFromMerchant:(BOOL)isSearchMerchant{

    
    dataArray = [NSMutableArray arrayWithCapacity:0];
        
    //!搜索的是商家
    if (isSearchMerchant) {//!先放入“商家”
        
        [dataArray addObject:@"商家"];
        [dataArray addObject:@"商品"];
        
    }else{//!先放入“商品”
        
        [dataArray addObject:@"商品"];
        [dataArray addObject:@"商家"];
    }
    
    [self setBtnTitle];
    
    

}
//!设置按钮的文字
-(void)setBtnTitle{

    [self.firstBtn setTitle:dataArray[0] forState:UIControlStateNormal];
    [self.secondBtn setTitle:dataArray[1] forState:UIControlStateNormal];


}
- (IBAction)firstBtnClick:(id)sender {
    
    //!改变自身的大小 收起或者展开
    [self changeHightAndHideSecond:YES];
    
}

//!第二个按钮 收起选中框，将第二个按钮的数据放到第一个
- (IBAction)secondBtnClick:(id)sender {
    
    [self secondBtnClick];
    
    
}
//!第二个按钮的点击事件调用的方法（为了方便外面能调用）
-(void)secondBtnClick{

    
    [dataArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
    
    [self setBtnTitle];//!改变按钮的数据

    //!改变自身的大小 收起或者展开
    [self changeHightAndHideSecond:YES];
    

}


//!右边的展开、收起 按钮
- (IBAction)selectBtnClick:(id)sender {
    
    //!改变自身的大小 收起或者展开
    [self changeHightAndHideSecond:NO];
    
}

-(void)changeHightAndHideSecond:(BOOL)isSelectBtn{//!传入参数：是否选择了“商家”/"商品"

    
    //!改变自身的大小  收起或者展开
    if (self.changHightBlock) {
        
        self.changHightBlock(isSelectBtn);
        
    }
    self.secondBtn.hidden = !self.secondBtn.hidden;
    

}



@end
