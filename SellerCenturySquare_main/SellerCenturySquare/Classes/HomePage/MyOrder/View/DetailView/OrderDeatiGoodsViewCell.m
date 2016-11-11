//
//  OrderDeatiGoodsViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OrderDeatiGoodsViewCell.h"

@implementation OrderDeatiGoodsViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.sizeView.backgroundColor = [UIColor whiteColor];

    [self.sizeLeftLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    
    
//    [self.goodsPriceLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
//    [self.goodsNumLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
    
    
    //!分割线
    [self.filterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configData:(orderGoodsItemDTO * )orderGoodsItemDTO isRetail:(BOOL)isRetail{
    
    self.isFromRetail = isRetail;//!从零售订单进入查看的
    
    //!先还原
    self.colorLeftLabel.hidden = NO;
    self.colorLabel.hidden = NO;
    
    self.sizeLeftLabel.hidden = NO;
    self.sizeView.hidden = NO;
    
    self.colorLeftLabel.text = @"颜色：";
    [self.colorLeftLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    self.colorLeftLabel.layer.borderWidth = 0;
    self.colorLeftLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.colorLeftLabel.font = [UIFont systemFontOfSize:15];


    //!设置公共的数据
    [self setCommonInfo:orderGoodsItemDTO];
    
    //!普通商品
    if ([orderGoodsItemDTO.cartType isEqualToString:@"0"]) {
        
        
        [self normalGoodsLayOut:orderGoodsItemDTO];
        
    }else if ([orderGoodsItemDTO.cartType isEqualToString:@"1"]){//!样板
    
        [self setSample];
        
    
    }else{//!邮费专拍
    
        [self setPostage];
    
    }
    
  
    

}
#pragma mark !设置公共的数据
-(void)setCommonInfo:(orderGoodsItemDTO * )orderGoodsItemDTO{

    //!商品图片
    [self.goodsImagView sd_setImageWithURL:[NSURL URLWithString:orderGoodsItemDTO.picUrl] placeholderImage:[UIImage imageNamed:@"post_placeholder"]];
    
    //!商品名称
    self.goodsNameLabel.text = orderGoodsItemDTO.goodsName;
    
    //!价钱
    NSMutableAttributedString * priceFirstStr = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:
                                           @{NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666 alpha:1],
                                             NSFontAttributeName:[UIFont systemFontOfSize:9]}];

    NSMutableAttributedString * priceSecondStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",[orderGoodsItemDTO.price floatValue]] attributes:
                                                 @{NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666 alpha:1],
                                                   NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    [priceFirstStr appendAttributedString:priceSecondStr];
    self.goodsPriceLabel.attributedText = priceFirstStr;

    
    //!商品件数
//    self.goodsNumLabel.text = [NSString stringWithFormat:@"x%@",orderGoodsItemDTO.quantity];

    NSMutableAttributedString * goodNumFirstStr = [[NSMutableAttributedString alloc]initWithString:@"x" attributes:
                                                 @{NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666 alpha:1],
                                                   NSFontAttributeName:[UIFont systemFontOfSize:9]}];
    
    NSMutableAttributedString * goodNumSecondStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",orderGoodsItemDTO.quantity] attributes:
                                                  @{NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666 alpha:1],
                                                    NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    [goodNumFirstStr appendAttributedString:goodNumSecondStr];
    self.goodsNumLabel.attributedText = goodNumFirstStr;

}

#pragma mark !普通商品
-(void)normalGoodsLayOut:(orderGoodsItemDTO * )orderGoodsItemDTO{


    
    //!颜色
    self.colorLabel.text = orderGoodsItemDTO.color;
    
    
    //!尺码
    for (UIView * subViews in self.sizeView.subviews) {
        
        [subViews removeFromSuperview];
    }
    
    //!组合出尺码数组
    NSArray * sizeArray = [orderGoodsItemDTO.sizes componentsSeparatedByString:@","];
    NSMutableArray * finallySizeArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString * sizeStr in sizeArray) {
        
        NSArray * sizeNewStrArray = [sizeStr componentsSeparatedByString:@":"];
        
        NSString * sizeNewStr;

        if (self.isFromRetail) {//!零售
            
            sizeNewStr = [NSString stringWithFormat:@"%@",sizeNewStrArray[0]];
            
        }else{//!批发
        
            sizeNewStr = [NSString stringWithFormat:@"%@x%@",sizeNewStrArray[0],sizeNewStrArray[1]];
        
        }
        
        [finallySizeArray addObject:sizeNewStr];
        
    }
    
    float sizeWidth = SCREEN_WIDTH - 15 - 60 - 15 - 45 - 50;
    float labelHight = 15;
    
    //!创建尺码
    UILabel * sizeLabel;
    for (int i = 0; i < finallySizeArray.count; i++) {
        
        UILabel * label = [[UILabel alloc]init];
        label.text = finallySizeArray[i];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHex:0x999999 alpha:1];
        label.layer.cornerRadius = 2;
        label.layer.masksToBounds = YES;
        label.layer.borderColor = [UIColor colorWithHex:0x999999 alpha:1].CGColor;
        label.layer.borderWidth = 0.5;
        
        
        //!计算大小
        CGSize labelSize = [self showSize:finallySizeArray[i]];
        if (i == 0) {
            
            label.frame = CGRectMake(0, 0, labelSize.width +15, labelHight);
            
        }else{
            
            label.frame = CGRectMake(CGRectGetMaxX(sizeLabel.frame) + 10, sizeLabel.frame.origin.y, labelSize.width + 15, labelHight);
            
        }
        
        //!重启一行
        if (CGRectGetMaxX(label.frame) > sizeWidth) {
            
            label.frame = CGRectMake(0, CGRectGetMaxY(sizeLabel.frame) + 5, labelSize.width + 15, labelHight);
        }
        
        [self.sizeView addSubview:label];
        
        sizeLabel = label;
        
    }
    
    self.sizeHight.constant = CGRectGetMaxY(sizeLabel.frame);
}

-(CGSize )showSize:(NSString *)price{
    
    CGSize showSize = [price boundingRectWithSize:CGSizeMake(self.sizeView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    
    return showSize;
    
    
}

#pragma mark 样板
-(void)setSample{

    self.colorLeftLabel.text = @" 样板 ";
    [self.colorLeftLabel setTextColor:[UIColor colorWithHex:0x000000 alpha:1]];
    self.colorLeftLabel.layer.borderWidth = 1;
    self.colorLeftLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.colorLeftLabel.font = [UIFont systemFontOfSize:12];
    self.colorLeftLabel.layer.masksToBounds = YES;
    self.colorLeftLabel.layer.cornerRadius = 2;

    
    self.colorLabel.hidden = YES;
    
    self.sizeLeftLabel.hidden = YES;
    self.sizeView.hidden = YES;


}

#pragma mark 邮费专拍
-(void)setPostage{

    self.colorLeftLabel.hidden = YES;
    self.colorLabel.hidden = YES;
    
    self.sizeLeftLabel.hidden = YES;
    self.sizeView.hidden = YES;

}
@end
