//
//  FilterView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/9/12.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    //!削圆
    self.allBtn.layer.masksToBounds = YES;
    self.allBtn.layer.cornerRadius = 2;
    
    self.in15DayBtn.layer.masksToBounds = YES;
    self.in15DayBtn.layer.cornerRadius = 2;
    
    self.after15DayBtn.layer.masksToBounds = YES;
    self.after15DayBtn.layer.cornerRadius = 2;
    
    self.after20DayBtn.layer.masksToBounds = YES;
    self.after20DayBtn.layer.cornerRadius = 2;
    
    self.after30DayBtn.layer.masksToBounds = YES;
    self.after30DayBtn.layer.cornerRadius = 2;
    
    //!文字颜色
    [self.allBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
    [self.allBtn setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:UIControlStateSelected];
    
    [self.in15DayBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
    [self.in15DayBtn setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:UIControlStateSelected];

    [self.after15DayBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
    [self.after15DayBtn setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:UIControlStateSelected];

    [self.after20DayBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
    [self.after20DayBtn setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:UIControlStateSelected];

    [self.after30DayBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
    [self.after30DayBtn setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:UIControlStateSelected];
    
    //!输入框的颜色
    self.leastPriceTextField.backgroundColor = [UIColor colorWithHexValue:0xf0f0f0 alpha:1];
    self.leastPriceTextField.textColor = [UIColor blackColor];
    self.leastPriceTextField.layer.masksToBounds = YES;
    self.leastPriceTextField.layer.cornerRadius = 2;
    
    self.mostPriceTextField.backgroundColor = [UIColor colorWithHexValue:0xf0f0f0 alpha:1];
    self.mostPriceTextField.textColor = [UIColor blackColor];
    self.mostPriceTextField.layer.masksToBounds = YES;
    self.mostPriceTextField.layer.cornerRadius = 2;

    self.toLabel.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];

    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tapGes];
    
    
    self.leastPriceTextField.delegate = self;
    self.mostPriceTextField.delegate = self;
    
    
}
//!点击空白处收起键盘
-(void)tapClick{

    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];

}

#pragma mark 统一设置按钮的颜色
-(void)setBtnColorSelectAll:(BOOL)selectAll selectIn15:(BOOL)selectIn15 selectAfter15:(BOOL)selectAfter15 selectAfter20:(BOOL)selectAfter20 selectAfter30:(BOOL)selectAfter30{

    //!默认全部是灰色，选中哪个，哪个就是黑色
    [self.allBtn setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    [self.in15DayBtn setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    [self.after15DayBtn setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    [self.after20DayBtn setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    [self.after30DayBtn setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    
    //!改变选中的状态
    self.allBtn.selected = selectAll;
    self.in15DayBtn.selected = selectIn15;
    self.after15DayBtn.selected = selectAfter15;
    self.after20DayBtn.selected = selectAfter20;
    self.after30DayBtn.selected = selectAfter30;

    if (selectAll) {
        
        [self.allBtn setBackgroundColor:[UIColor colorWithHexValue:0x000000 alpha:1]];

    }else if (selectIn15){
    
        [self.in15DayBtn setBackgroundColor:[UIColor colorWithHexValue:0x000000 alpha:1]];

    }else if (selectAfter15){
    
        [self.after15DayBtn setBackgroundColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    
    }else if (selectAfter20){
    
        [self.after20DayBtn setBackgroundColor:[UIColor colorWithHexValue:0x000000 alpha:1]];

    }else if (selectAfter30){
    
        [self.after30DayBtn setBackgroundColor:[UIColor colorWithHexValue:0x000000 alpha:1]];

    
    }

    
}

#pragma mark 点击事件
//!全部
- (IBAction)allBtnClick:(id)sender {
    
    [self setBtnColorSelectAll:YES selectIn15:NO selectAfter15:NO selectAfter20:NO selectAfter30:NO];
    
    [self.upSortDic removeObjectForKey:@"upDayNum"];
    
}
//!15天内
- (IBAction)in15DayBtnClick:(id)sender {
    
    [self setBtnColorSelectAll:NO selectIn15:YES selectAfter15:NO selectAfter20:NO selectAfter30:NO];

    [self.upSortDic setObject:@"-15" forKey:@"upDayNum"];
}
//!15天前
- (IBAction)after15DayBtnClick:(id)sender {

    [self setBtnColorSelectAll:NO selectIn15:NO selectAfter15:YES selectAfter20:NO selectAfter30:NO];

    [self.upSortDic setObject:@"15" forKey:@"upDayNum"];

}
//!20天前
- (IBAction)after20DayBtnClick:(id)sender {
    
    [self setBtnColorSelectAll:NO selectIn15:NO selectAfter15:NO selectAfter20:YES selectAfter30:NO];

    [self.upSortDic setObject:@"20" forKey:@"upDayNum"];

}
//!30天前
- (IBAction)after30DayBtnClick:(id)sender {
    
    [self setBtnColorSelectAll:NO selectIn15:NO selectAfter15:NO selectAfter20:NO selectAfter30:YES];

    [self.upSortDic setObject:@"30" forKey:@"upDayNum"];

}
#pragma mark TextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{

   
    NSString * leastStr = self.leastPriceTextField.text;
    NSString * mostStr = self.mostPriceTextField.text;
    
    
    //1、判断是否需要交互 最低价和最高价的位置
    NSString * tempStr = @"";

    if (leastStr.length && mostStr.length) {//!都输入了
        
        if ([leastStr doubleValue] > [mostStr doubleValue]) {//!输入的最低价 > 输入的最高价 ，则交互两个textfield的值
            tempStr = leastStr;
            leastStr = mostStr;
            mostStr = tempStr;
            
            self.leastPriceTextField.text = leastStr;
            self.mostPriceTextField.text = mostStr;
            
        }
        
    }
    
  

}

//!初始化数据
-(void)configData:(NSDictionary *)sortDic{

    NSString * upDayNum = sortDic[@"upDayNum"];
    if (upDayNum) {//上新时间-15:15天内，15:15天前，20:20天前，30:30天前
        
        if ([upDayNum isEqualToString:@"-15"]) {
            
            [self setBtnColorSelectAll:NO selectIn15:YES selectAfter15:NO selectAfter20:NO selectAfter30:NO];

        }else if ([upDayNum isEqualToString:@"15"]){
            
            [self setBtnColorSelectAll:NO selectIn15:NO selectAfter15:YES selectAfter20:NO selectAfter30:NO];

        }else if ([upDayNum isEqualToString:@"20"]){
        
            [self setBtnColorSelectAll:NO selectIn15:NO selectAfter15:NO selectAfter20:YES selectAfter30:NO];

        }else if ([upDayNum isEqualToString:@"30"]){
            
            [self setBtnColorSelectAll:NO selectIn15:NO selectAfter15:NO selectAfter20:NO selectAfter30:YES];

        }else{
        
            [self setBtnColorSelectAll:YES selectIn15:NO selectAfter15:NO selectAfter20:NO selectAfter30:NO];

        }
        
    }else{//!没有值，说明选中的是“”全部
    
        [self setBtnColorSelectAll:YES selectIn15:NO selectAfter15:NO selectAfter20:NO selectAfter30:NO];
    
    }
    
    //!最低价
    self.leastPriceTextField.text = sortDic[@"minPrice"];
    
    //!最高价
    self.mostPriceTextField.text = sortDic[@"maxPrice"];


    _upSortDic = [NSMutableDictionary dictionaryWithDictionary:sortDic];
    
    
}

//!重置
- (IBAction)resetBtnClick:(id)sender {
    
    [self configData:@{}];
    
}

//!确定
- (IBAction)sureBtnClick:(id)sender {
    
    NSString * leastStr = self.leastPriceTextField.text;
    NSString * mostStr = self.mostPriceTextField.text;
    
    //1、判断输入的长度是否合法
    if (leastStr.length > 9 || mostStr.length > 9) {
        
        [self makeMessage:@"最多可输入9位数字" duration:2.0 position:@"center"];
        
        return;
    }
    
    
    if (leastStr.length) {
        
        [self.upSortDic setObject:leastStr forKey:@"minPrice"];
    }else{
    
        [self.upSortDic removeObjectForKey:@"minPrice"];
    }
    
    if (mostStr.length) {
        
        [self.upSortDic setObject:mostStr forKey:@"maxPrice"];
    }else{
    
        [self.upSortDic removeObjectForKey:@"maxPrice"];

    
    }
    
    if (self.sureToSortBlock) {
        
        self.sureToSortBlock(self.upSortDic);
        
    }


    
}

@end
