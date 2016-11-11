//
//  SizeViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SizeViewCell.h"

@implementation SizeViewCell

- (void)awakeFromNib {
    // Initialization code


    
}

-(void)configData:(GetGoodsInfoListDTO *)goodsInfoDTO{

    
    cellGoodsInfoDTO = goodsInfoDTO;
    
    for (UIView * childViews in self.contentView.subviews) {
        
        [childViews removeFromSuperview];
        
    }
    
    //!尺寸
    UILabel * sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 55, 30)];
    [sizeLabel setText:@"尺码:"];
    [sizeLabel setFont:[UIFont systemFontOfSize:12]];
    [sizeLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
    [self.contentView addSubview:sizeLabel];
    
    NSString * stockFlag;
    
    UIButton * upBtn;//!上一个btn
    
    for (int i = 0; i < goodsInfoDTO.skuDTOList.count; i++) {
        
        UIButton * skuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [skuBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        skuBtn.tag = 100+i;
        skuBtn.layer.masksToBounds = YES;
        skuBtn.layer.cornerRadius = 2;
        [skuBtn addTarget:self action:@selector(skuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        SkuDTO * skuDTO = goodsInfoDTO.skuDTOList[i];
        
        if ([skuDTO.showStockFlag isEqualToString:@"1"]) {
            
            stockFlag = @"有货";
            [skuBtn setBackgroundColor:[UIColor blackColor]];

        
        }else{
        
            stockFlag = @"无货";
            [skuBtn setBackgroundColor:[UIColor colorWithHex:0xe2e2e2 alpha:1]];

        
        }
        NSString *showNameStr = [NSString stringWithFormat:@"%@ %@",skuDTO.skuName,stockFlag];
        [skuBtn setTitle:showNameStr forState:UIControlStateNormal];
        CGSize skuSize = [self showSkuNameSize:showNameStr];
        
        //!确定是第几行
        if (!upBtn) {//!还没有上一个button，则是第一个要布局的button
            
            skuBtn.frame = CGRectMake(15 , CGRectGetMaxY(sizeLabel.frame), skuSize.width +14, 24);
            
            
        }else{//!非第一个button
        
            //!先把当前的btn相对于前一个button后移，y不变
            skuBtn.frame = CGRectMake(CGRectGetMaxX(upBtn.frame) + 10, upBtn.frame.origin.y, skuSize.width +14, upBtn.frame.size.height);
            
            //!判断当前button是否已经超过了屏幕
            float skuWidth = CGRectGetMaxX(skuBtn.frame);
            if (skuWidth >= SCREEN_WIDTH) {//!重新起一行
                
                
                skuBtn.frame = CGRectMake(15, CGRectGetMaxY(upBtn.frame)+10, upBtn.frame.size.width, upBtn.frame.size.height);
                
            }
            
        
        }
        
        upBtn = skuBtn;
        
        [self.contentView addSubview:skuBtn];
        
        
    }
    
    
    self.cellHight = CGRectGetMaxY(upBtn.frame) +20;
    
    filterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.cellHight - 0.5, SCREEN_WIDTH, 0.5)];
    [filterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];

    [self.contentView addSubview:filterLabel];

}


-(CGSize )showSkuNameSize:(NSString *)showName{

    CGSize showSize = [showName boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;

    return showSize;
    

}

-(void)skuBtnClick:(UIButton *)skuBtn{

    
    NSInteger btnTag = skuBtn.tag - 100;
    SkuDTO * skuDTO = cellGoodsInfoDTO.skuDTOList[btnTag];
    
    if ([skuDTO.showStockFlag isEqualToString:@"1"]) {//!有货，修改为无货
        
        skuDTO.showStockFlag = @"0";//!无货
        
        //!更改文字
        NSString *showNameStr = [NSString stringWithFormat:@"%@ %@",skuDTO.skuName,@"无货"];
        [skuBtn setTitle:showNameStr forState:UIControlStateNormal];
        
        //!更改背景
        [skuBtn setBackgroundColor:[UIColor colorWithHex:0xe2e2e2 alpha:1]];
        
        
    }else{//!无货，修改为有货
        
        skuDTO.showStockFlag = @"1";//!有货
        
        //!更改文字
        NSString *showNameStr = [NSString stringWithFormat:@"%@ %@",skuDTO.skuName,@"有货"];
        [skuBtn setTitle:showNameStr forState:UIControlStateNormal];
        
        //!更改背景
        [skuBtn setBackgroundColor:[UIColor blackColor]];

        
    }
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
