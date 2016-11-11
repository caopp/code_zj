//
//  CSPGoodsTableViewCell.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsTableViewCell.h"
#import "GetMerchantInfoDTO.h"
@implementation CSPGoodsTableViewCell

- (void)awakeFromNib{
    

    [self.goodsColorTitleLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
    [self.goodsColorLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    
    [self.centeFilterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];
    self.centerFilterHight.constant = 0.5;
    
    [self.bottomFilterLabel setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];
    

    self.firstOnSaleTitleLabel.textColor = [UIColor colorWithHex:0x666666 alpha:1];
    
    [self.vipPriceView setBackgroundColor:[UIColor whiteColor]];
    
    [self.saleTypeLabel setTextColor:[UIColor colorWithHex:0x999999]];
    
    [self.wholesaleLabel setTextColor:[UIColor colorWithHex:0xfd4f57]];
    
    [self.retailLabel setTextColor:[UIColor colorWithHex:0x09bb07]];
    
    //!削圆
    self.groundingButton.layer.masksToBounds = YES;
    self.groundingButton.layer.cornerRadius = 2.0;
    
    
}


//!处理数据
-(void)configData:(EditGoodsDTO *)editGoodsDTO{


    //!图片
    [self.goodsimageView sd_setImageWithURL:[NSURL URLWithString:editGoodsDTO.imgUrl] placeholderImage:[UIImage imageNamed:DOWNLOAD_DEFAULTIMAGE]];
    //!商品名称
    self.goodsTitleLabel.text = editGoodsDTO.goodsName;
    //!商品颜色
    self.goodsColorLabel.text = editGoodsDTO.color;

    
    for (UIView * priceLabelView in self.vipPriceView.subviews) {
        
        [priceLabelView removeFromSuperview];
        
    }
    
    //!第一次上架时间 新发布未上架 的时候不显示
    if ([editGoodsDTO.goodsStatus isEqualToString:@"1"]) {
        
        self.firstOnSaleTitleLabel.hidden = YES;
    
    }else{
        
        self.firstOnSaleTitleLabel.hidden = NO;

        self.firstOnSaleTitleLabel.text = [NSString stringWithFormat:@"第一次上架时间：%@",editGoodsDTO.firstOnsaleTime];
    
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
    
    
    //!!!!!!!!!!!!!!!界面布局更改后，这里是数字也要更改（cellHight 的地方也要改变、搜索列表的cell 和搜索列表计算cell高度的地方也要变）
    
    CGFloat priceViewWidth = [UIScreen mainScreen].bounds.size.width - (15 +60) - 15 - 30;//!减去 图片距离前面的距离 、图片宽高、价格view距离前面的距离、价格view距离后面的距离 = 价格view的宽度
    
    //!计算价格view的高度
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
        
        [self.vipPriceView addSubview:vipLabel];

        
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
    
    priceLabel =nil;

    //!批发、在售
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
    
    CGSize showSize = [price boundingRectWithSize:CGSizeMake(self.vipPriceView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
    
    return showSize;
    
    
}


//上架或下架
- (IBAction)groundingButtonClick:(id)sender {
    
    if ([GetMerchantInfoDTO sharedInstance].isMaster) {
        
        //!如果是在未发布的地方点击
        if (self.isNotPublish) {
            // !商家歇业
            if ([GetMerchantInfoDTO sharedInstance].operateStatus == NO) {
                
                self.cannotChangeStatus(@"歇业中，不可上架商品。");

            }else if ([[GetMerchantInfoDTO sharedInstance].merchantStatus isEqualToString:@"1"]){// !关闭
            
                if (self.cannotChangeStatus) {
                    
                    self.cannotChangeStatus(@"商家关闭，不可上架商品。");
               
                }
            
            }else{
            
                self.goodsStatusOperation(self.goodsNo,self.goodsStatus);

            }
            
            
        }else{
        
            self.goodsStatusOperation(self.goodsNo,self.goodsStatus);
        
        }
        
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//        
//        [dic setObject:self.goodsNo forKey:@"goodsNo"];
//        
//        [dic setObject:self.goodsStatus forKey:@"goodsStatus"];
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:K_NOTICE_GOODSSTATEOPERATION object:dic];
        
        
        
    }else{
        // !不会走这里 因为子账号不能看这个界面
        [self tipNotOperation];
    
        
    }
}

- (void)tipNotOperation{
    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"子账号不可执行上架、下架操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    
//    [alertView show];
    
    
    
}


@end
