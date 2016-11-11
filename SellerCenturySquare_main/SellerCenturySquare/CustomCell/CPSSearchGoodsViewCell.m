//
//  CPSSearchGoodsViewCell.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSSearchGoodsViewCell.h"

@implementation CPSSearchGoodsViewCell

- (void)awakeFromNib{
    
    self.goodsTitleLabel.textColor = [UIColor blackColor];
    
    self.goodsColorLabel.textColor = [UIColor colorWithHex:0x666666];
    
    self.goodsPlaceLabel.textColor = HEX_COLOR(0xeb301fFF);
    
    
    [self.priceView setBackgroundColor:[UIColor whiteColor]];
    
    [self.firstSaleTimeLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    [self.saleTypeLabel setTextColor:[UIColor colorWithHex:0x999999]];
    [self.retailLabel setTextColor:[UIColor colorWithHex:0x09bb07]];
    [self.wholesaleLabel setTextColor:[UIColor colorWithHex:0xfd4f57]];
    
    
    
    
}

-(void)configData:(EditGoodsDTO *)editGoodsDTO{

    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:editGoodsDTO.imgUrl] placeholderImage:[UIImage imageNamed:@""]];

    self.goodsTitleLabel.text = editGoodsDTO.goodsName;
    
    self.goodsColorLabel.text = [NSString stringWithFormat:@"颜色：%@",editGoodsDTO.color];
    
    self.goodsPlaceLabel.text = [NSString stringWithFormat:@"￥%@",editGoodsDTO.price.stringValue];

    //!删除价格view上面的控件
    for (UIView * childView in [self.priceView subviews]) {
        
        [childView removeFromSuperview];
        
    }
    NSMutableArray * vipPriceArray = [NSMutableArray arrayWithCapacity:0];
    
  
    NSDictionary * price6Dic = @{@"level":@"6",
                                 @"price":editGoodsDTO.price6};
    [vipPriceArray addObject:price6Dic];
    
    NSDictionary * price5Dic = @{@"level":@"5",
                                 @"price":editGoodsDTO.price5};
    [vipPriceArray addObject:price5Dic];
    
    NSDictionary * price4Dic = @{@"level":@"4",
                                 @"price":editGoodsDTO.price4};
    [vipPriceArray addObject:price4Dic];
    
    
    NSDictionary * price3Dic = @{@"level":@"3",
                                 @"price":editGoodsDTO.price3};
    
    [vipPriceArray addObject:price3Dic];
    
    
    NSDictionary * price2Dic = @{@"level":@"2",
                                 @"price":editGoodsDTO.price2};
    
    [vipPriceArray addObject:price2Dic];
    
    NSDictionary * price1Dic = @{@"level":@"1",
                                 @"price":editGoodsDTO.price1};
    
    [vipPriceArray addObject:price1Dic];
    
    
    CGFloat priceViewWidth = SCREEN_WIDTH - (15 +60) - 15 - 30;//!减去 图片距离前面的距离 、图片宽高、价格view距离前面的距离、价格view距离后面的距离 = 价格view的宽度

    //!价格
    UILabel * priceLabel;
    for (int i = 0 ; i < vipPriceArray.count ; i ++ ) {
        
        NSDictionary * priceDic = vipPriceArray[i];
        
        
        
        NSString * levelStr = [NSString stringWithFormat:@"[V%@] ",priceDic[@"level"]];
        
        NSMutableAttributedString * levelString = [[NSMutableAttributedString alloc]initWithString:levelStr attributes:
                                                   @{NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666 alpha:1],
                                                     NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        
        NSMutableAttributedString * priceSting = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",priceDic[@"price"]] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        
        [levelString appendAttributedString:priceSting];
        
        CGSize vipLabelSize = [self showVIPPriceSize:[NSString stringWithFormat:@"[V%@] ￥%@",priceDic[@"level"],priceDic[@"price"]]];
        
        
        UILabel * vipLabel = [[UILabel alloc]init];
        vipLabel.attributedText = levelString;
        
        [self.priceView addSubview:vipLabel];
        
        
        if (!priceLabel) {//!还没有记录下label来，就是第一个
            
            vipLabel.frame = CGRectMake(0, 0, vipLabelSize.width, vipLabelSize.height);
            
        }else{
            
            vipLabel.frame = CGRectMake(CGRectGetMaxX(priceLabel.frame)+13, priceLabel.frame.origin.y, vipLabelSize.width, vipLabelSize.height);
            
            float vipWidth = CGRectGetMaxX(vipLabel.frame);
            
            
            if (vipWidth > priceViewWidth) {//!重新起一行
                
                
                vipLabel.frame = CGRectMake(0, CGRectGetMaxY(priceLabel.frame)+10, vipLabelSize.width, vipLabelSize.height);
                
                
            }
            
            
        }
        
        priceLabel = vipLabel;//!记录下来
        
    }
    
    self.priceViewHight.constant = CGRectGetMaxY(priceLabel.frame);//! 价格view 的高度 = 最后一个label 的 CGRectGetMaxY
    
    //!第一次上架时间
    self.firstSaleTimeLabel.text = [NSString stringWithFormat:@"第一次上架时间：%@",editGoodsDTO.firstOnsaleTime];
    
    //!销售渠道
    self.wholesaleLabel.text = @"";
    self.retailLabel.text = @"";

    NSArray * channelArray = [editGoodsDTO.channelList componentsSeparatedByString:@","];
    for (NSString * channel in channelArray) {
        
        //!批发
        if ([channel isEqualToString:@"0"]) {
            
            self.wholesaleLabel.text = @"批发";
            
        }
        
        if ([channel isEqualToString:@"1"]) {
            
            self.retailLabel.text = @"零售";
        }
        
        
    }
    
}
-(CGSize )showVIPPriceSize:(NSString *)price{
    
    CGSize showSize = [price boundingRectWithSize:CGSizeMake(self.priceView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
    
    return showSize;
    
    
}


@end
