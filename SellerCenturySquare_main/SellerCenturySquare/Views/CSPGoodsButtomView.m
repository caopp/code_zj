//
//  CSPGoodsButtomView.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsButtomView.h"
#import "ACMacros.h"
#import "GetMerchantInfoDTO.h"
@implementation CSPGoodsButtomView

- (void)awakeFromNib{
    
    self.operationBtn.backgroundColor = [UIColor lightGrayColor];
    
    self.operationBtn.layer.masksToBounds = YES;
    self.operationBtn.layer.cornerRadius = 2;
    
    UIView *buttomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, Main_Screen_Width, 0.5)];
    buttomLine.backgroundColor = [UIColor whiteColor];
    buttomLine.alpha = 0.5;
    [self addSubview:buttomLine];
    
    
    [self.leftBtn setBackgroundColor:[UIColor colorWithHex:0xf9f9f9]];
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftBtn.titleLabel.numberOfLines = 0;
    
    [self.rightBtn setBackgroundColor:[UIColor colorWithHex:0x1a1a1a]];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.rightBtn.titleLabel.numberOfLines = 0;

    
    self.filterLabel.backgroundColor = [UIColor colorWithHex:0x999999];
    
    
}

//!上下架操作
- (IBAction)operationBtnClick:(id)sender {
    
    if ([GetMerchantInfoDTO sharedInstance].isMaster) {
        
        self.goodsOperation();
        
        
    }else{
        [self tipNotOperation];
    }
    
}


//!全选
- (IBAction)selectedButtonClick:(id)sender {
    
     
    
//    [self.delegete selectedAll];
    if (self.selectedAllGoods) {
        self.selectedAllGoods();
 
        
    }
}

//!设置底部按钮的文字
-(void)configBottom:(ChannelType)channelType{

    self.channelType = channelType;
    
    
    switch (channelType) {
        case ChannelType_All://!全部 不显示底部两个按钮
        {
        
            
            
        }
            break;
        case ChannelType_Wholse:{//!批发
        
            [self.leftBtn setTitle:@"加入零售渠道" forState:UIControlStateNormal];
            
            [self.rightBtn  setTitle:@"加入零售并从\n批发渠道移除" forState:UIControlStateNormal];
            
        }
            break;
        case ChannelType_Retail:{//!零售
        
            [self.leftBtn setTitle:@"加入批发渠道" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"加入批发并从\n零售渠道移除" forState:UIControlStateNormal];
            
        
        }
            break;
        case ChannelType_WholseAndRetail:{//!批发/零售
        
            [self.leftBtn setTitle:@"从批发渠道移除" forState:UIControlStateNormal];
            
            [self.rightBtn setTitle:@"从零售渠道移除" forState:UIControlStateNormal];
        
        }
            break;
            
        default:
            break;
    }
    
    


}

- (IBAction)bottomLeftBtnClick:(id)sender {
    
    if (self.leftBtnClickBlock) {
        
        self.leftBtnClickBlock();
        
    }
    
    
}

- (IBAction)bottomRightBtnClick:(id)sender {
    
    
    if (self.rightBtnClickBlock) {
        
        self.rightBtnClickBlock();
        
    }
    
}



@end
