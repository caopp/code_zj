//
//  WholeAndRetailSegmentView.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/20.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "WholeAndRetailSegmentView.h"

@implementation WholeAndRetailSegmentView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //!按钮 正常、选中 状态下的文字颜色
    [self setTitleColor:self.allBtn];
    [self setTitleColor:self.wholesaleBtn];
    [self setTitleColor:self.wholesaleAndRetailBtn];
    [self setTitleColor:self.retailBtn];
    
    
}
#pragma mark 根据所有按钮的状态设置按钮的背景颜色
-(void)setBgColorWithAllStatus:(BOOL)allSelect wholesaleStatus:(BOOL)wholeSaleSelect  retailStatus:(BOOL)retailSelect  wholesaleAndRetailStatus:(BOOL)wholesaleAndRetailSelect {
    
    //!全部
    if (allSelect) {
        
        [self setBtnSelect:self.allBtn];
        
        
    }else{
    
        [self setBtnNormal:self.allBtn];
        
    }
    
    //!批发
    if (wholeSaleSelect) {
        
        [self setBtnSelect:self.wholesaleBtn];
        

    }else{
        
        [self setBtnNormal:self.wholesaleBtn];
        
    }
    
  
    
    //!零售
    if (retailSelect) {
        
        [self setBtnSelect:self.retailBtn];
        

    }else{
    
        [self setBtnNormal:self.retailBtn];

    }
    
    //!批发/零售
    if (wholesaleAndRetailSelect) {
        
        [self setBtnSelect:self.wholesaleAndRetailBtn];
        
        
    }else{
        
        [self setBtnNormal:self.wholesaleAndRetailBtn];
        
    }
    
    
    
    
}

//!按钮正常状态下的背景颜色
-(void)setBtnNormal:(UIButton *)btn{


    [btn setBackgroundColor:[UIColor colorWithHex:0xd9d9d9]];
    
}

//!按钮选中状态下的背景颜色
-(void)setBtnSelect:(UIButton *)btn{


    [btn setBackgroundColor:[UIColor whiteColor]];

    
}

//!按钮 正常、选中 状态下的文字颜色
-(void)setTitleColor:(UIButton *)btn{

    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];


}


#pragma mark 点击事件
//!全部
- (IBAction)allBtnClick:(id)sender {
    

    self.allBtn.selected = YES;
    self.wholesaleBtn.selected = NO;
    self.wholesaleAndRetailBtn.selected = NO;
    self.retailBtn.selected = NO;
    
    [self setBgColorWithAllStatus:YES wholesaleStatus:NO retailStatus:NO wholesaleAndRetailStatus:NO];
    
    //!“在售”的各个状态：销售渠道 -1 全部 0 批发 1 零售 2批发和零售
    if (self.changetypeBlock) {
        
        self.changetypeBlock(@"-1");
    }
    
}


//!批发
- (IBAction)wholesaleBtnClick:(id)sender {
    
    self.allBtn.selected = NO;
    self.wholesaleBtn.selected = YES;
    self.wholesaleAndRetailBtn.selected = NO;
    self.retailBtn.selected = NO;
    
    [self setBgColorWithAllStatus:NO wholesaleStatus:YES retailStatus:NO wholesaleAndRetailStatus:NO];
    
    //!“在售”的各个状态：销售渠道 -1 全部 0 批发 1 零售 2批发和零售
    if (self.changetypeBlock) {
        
        self.changetypeBlock(@"0");
    }


}
//!零售
- (IBAction)retailBtnClick:(id)sender {
    
    self.allBtn.selected = NO;
    self.wholesaleBtn.selected = NO;
    self.wholesaleAndRetailBtn.selected = NO;
    self.retailBtn.selected = YES;
    
    [self setBgColorWithAllStatus:NO wholesaleStatus:NO retailStatus:YES wholesaleAndRetailStatus:NO];
    
    
    //!“在售”的各个状态：销售渠道 -1 全部 0 批发 1 零售 2批发和零售
    if (self.changetypeBlock) {
        
        self.changetypeBlock(@"1");
    }

    
    
}

//!批发/零售
- (IBAction)wholesaleAndRetailBtnClick:(id)sender {
    
    self.allBtn.selected = NO;
    self.wholesaleBtn.selected = NO;
    self.wholesaleAndRetailBtn.selected = YES;
    self.retailBtn.selected = NO;

    [self setBgColorWithAllStatus:NO wholesaleStatus:NO retailStatus:NO wholesaleAndRetailStatus:YES];
    
    //!“在售”的各个状态：销售渠道 -1 全部 0 批发 1 零售 2批发和零售
    if (self.changetypeBlock) {
        
        self.changetypeBlock(@"2");
    }


}


#pragma mark 根据选中的index 设定按钮的状态
-(void)setSelectBtnType:(NSString *)selectType{
    

    //!“在售”的各个状态：销售渠道 -1 全部 0 批发 1 零售 2批发和零售
    
    if ([selectType isEqualToString:@"-1"]) {

        self.allBtn.selected = YES;
        [self setBgColorWithAllStatus:YES wholesaleStatus:NO retailStatus:NO wholesaleAndRetailStatus:NO];

        
    }else if ([selectType isEqualToString:@"0"]){
    
        self.wholesaleBtn.selected = YES;
        [self setBgColorWithAllStatus:NO wholesaleStatus:YES retailStatus:NO wholesaleAndRetailStatus:NO];

        
    }else if ([selectType isEqualToString:@"1"]){
    
        self.retailBtn.selected = YES;
        
        [self setBgColorWithAllStatus:NO wholesaleStatus:NO retailStatus:YES wholesaleAndRetailStatus:NO];

    }else{
    
        self.wholesaleAndRetailBtn.selected = YES;
        [self setBgColorWithAllStatus:NO wholesaleStatus:NO retailStatus:NO wholesaleAndRetailStatus:YES];

    }
    
   

}


@end
