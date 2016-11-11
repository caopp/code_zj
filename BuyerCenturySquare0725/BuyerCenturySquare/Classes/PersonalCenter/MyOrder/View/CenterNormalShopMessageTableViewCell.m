//
//  CenterNormalShopMessageTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CenterNormalShopMessageTableViewCell.h"



@implementation CenterNormalShopMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//采购单列表
- (void)setOrderDetailMessageDto:(OrderDetailMesssageDTO *)orderDetailMessageDto
{
    [super setOrderDetailMessageDto:orderDetailMessageDto];
    if (orderDetailMessageDto &&orderDetailMessageDto != nil) {
                
        [self.goodsPhotoImage sd_setImageWithURL:[NSURL URLWithString:orderDetailMessageDto.picUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
        self.goodsNameLab.text = orderDetailMessageDto.goodsName;
        self.goodsColorLab.text = orderDetailMessageDto.color;
//        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:10]}];
        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

        
        
        NSString *goodsPriceString = [NSString stringWithFormat:@"%.2f",orderDetailMessageDto.price.doubleValue];
        
        
//        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:16]}];
        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

        [priceString appendAttributedString:priceValueString];
        self.goodsPriceLab.attributedText = priceString;

//        self.goodsPriceLab.text = [NSString stringWithFormat:@"%.2f",orderDetailMessageDto.price.doubleValue];
        
        
        
        self.goodsNumbLab.text = [NSString stringWithFormat:@"x%ld",(long)orderDetailMessageDto.quantity.integerValue];
    
        NSArray *arrSub = self.sizesView.subviews;
        for (UILabel *lab in arrSub) {
            if (lab) {
                [lab removeFromSuperview];
            }
        }

        if ( orderDetailMessageDto.sizes.count) {
            NSArray *sizeArr = orderDetailMessageDto.sizes;
            
            if (sizeArr.count>0) {
                
                UILabel *recordLab;
                CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width-138;
                
                
                CGFloat lastWidth;
                CGFloat indexX = 0;
                CGFloat indexY = 0;
                
                for (int i = 0; i<sizeArr.count; i++) {
                    
                    
                    if (i >0) {
                        lastWidth = [self accordingContentFont:sizeArr[(i-1)]].width;
                    }else
                    {
                        lastWidth = [self accordingContentFont:sizeArr[i]].width;
                        
                    }
                    CGFloat orginX =recordLab?(CGRectGetMaxX(recordLab.frame)+10):0;
                    
                    if (viewWidth<CGRectGetMaxX(recordLab.frame)) {
                        indexX = 0 ;
                        orginX = 0;
                        
                        indexY ++;
                    }
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(orginX, 22*indexY, [self accordingContentFont:sizeArr[i]].width+15, 15)];
                    
                    
                    if (viewWidth<CGRectGetMaxX(label.frame)){
                        indexX = 0 ;
                        indexY ++;
                        orginX = 0;
                        CGRect frame = label.frame;
                        frame = CGRectMake(orginX, 22*indexY, [self accordingContentFont:sizeArr[i]].width+15, 15);
                        label.frame = frame;
                    }
                    
                    
                    
                    
                    label.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;
                    label.layer.borderWidth = 0.5f;
                    label.layer.cornerRadius = 2;
                    label.layer.masksToBounds = YES;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
                    [self.sizesView addSubview:label];
                    label.text = sizeArr[i];
                    label.font = [UIFont systemFontOfSize:13];
                    indexX ++ ;
                    
                    recordLab = label;
                    
                    
                    label.numberOfLines = 1;
                    label.adjustsFontSizeToFitWidth = YES;
                    
                }
            }
            
            
            
        }
        
    }
}

//采购单详情
- (void)setGoodsItemDto:(OrderGoodsItem *)goodsItemDto
{
    [super setGoodsItemDto:goodsItemDto];
    
    
    if (goodsItemDto) {
        
        [self.goodsPhotoImage sd_setImageWithURL:[NSURL URLWithString:goodsItemDto.picUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
        self.goodsNameLab.text = goodsItemDto.goodsName;
        self.goodsColorLab.text = goodsItemDto.color;
        
        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

        NSString *goodsPriceString = [NSString stringWithFormat:@"%.2f",goodsItemDto.price];
        
        
        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

        [priceString appendAttributedString:priceValueString];
        self.goodsPriceLab.attributedText = priceString;
        
        

        

        
        
        self.goodsNumbLab.text = [NSString stringWithFormat:@"x%ld",(long)goodsItemDto.quantity];
        
        NSArray *arrSub = self.sizesView.subviews;
        for (UILabel *lab in arrSub) {
            if (lab) {
                [lab removeFromSuperview];
            }
        }
        
        if ( goodsItemDto.sizes.count) {
            NSArray *sizeArr = goodsItemDto.sizes;
            
            if (sizeArr.count>0) {
                
                UILabel *recordLab;
                CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width-138;
                
                
                CGFloat lastWidth;
                CGFloat indexX = 0;
                CGFloat indexY = 0;
                
                for (int i = 0; i<sizeArr.count; i++) {
                    
                    
                    if (i >0) {
                        lastWidth = [self accordingContentFont:sizeArr[(i-1)]].width;
                    }else
                    {
                        lastWidth = [self accordingContentFont:sizeArr[i]].width;
                        
                    }
                    CGFloat orginX =recordLab?(CGRectGetMaxX(recordLab.frame)+10):0;
                    
                    if (viewWidth<CGRectGetMaxX(recordLab.frame)) {
                        indexX = 0 ;
                        orginX = 0;
                        
                        indexY ++;
                    }
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(orginX, 22*indexY, [self accordingContentFont:sizeArr[i]].width+15, 15)];
                    
                    
                    if (viewWidth<CGRectGetMaxX(label.frame)){
                        indexX = 0 ;
                        indexY ++;
                        orginX = 0;
                        CGRect frame = label.frame;
                        frame = CGRectMake(orginX, 22*indexY, [self accordingContentFont:sizeArr[i]].width+15, 15);
                        label.frame = frame;
                    }
                    
                    
                    
                    
                    label.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;
                    label.layer.borderWidth = 0.5f;
                    label.layer.cornerRadius = 2;
                    label.layer.masksToBounds = YES;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
                    [self.sizesView addSubview:label];
                    label.text = sizeArr[i];
                    label.font = [UIFont systemFontOfSize:13];
                    indexX ++ ;
                    
                    recordLab = label;
                    
                    
                    label.numberOfLines = 1;
                    label.adjustsFontSizeToFitWidth = YES;
                    
                }
            }



        }
        
    }
}
- (void)setHideLine:(NSString *)hideLine
{
    if (hideLine.length>0) {
//        self.lineView.hidden = YES;
        
    }
}


- (CGSize)accordingContentFont:(NSString *)str
{
    
    CGSize size;
    size=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    
    return size;
    
}



@end
