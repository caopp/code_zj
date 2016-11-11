//
//  CSPGoodsCollectionViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPGoodsCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommodityGroupListDTO.h"
#import "CSPUtils.h"

@implementation CSPGoodsCollectionViewCell

- (void)awakeFromNib {
    
    self.swearImageView.contentMode = UIViewContentModeScaleAspectFill; // 这是整个view会被图片填满，图片比例不变 ，这样图片显示就会大于view
    
    self.swearImageView.clipsToBounds = YES;
    
    
}


- (void)setCommodityInfo:(Commodity *)commodityInfo {

    _commodityInfo = commodityInfo;



    if (commodityInfo.dayNum == 0) {
        
        self.dayNumLabel.text = @"3";
        self.dayNumUnitLabel.text = NSLocalizedString(@"inDay", @"天\n内");
        
    }else{
        
        self.dayNumUnitLabel.text = NSLocalizedString(@"outDay", @"天\n前");
        self.dayNumLabel.text = [NSString stringWithFormat:@"%ld", commodityInfo.dayNum];
    
    }

    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];

    NSString* priceValue = [CSPUtils isRoundNumber:commodityInfo.price] ? [NSString stringWithFormat:@"%ld", (long)commodityInfo.price] : [NSString stringWithFormat:@"%.02f", commodityInfo.price];
    
    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:priceValue attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:22]}];

    [priceString appendAttributedString:priceValueString];

    self.priceLabel.attributedText = priceString;

    self.swearTitleLabel.text = commodityInfo.goodsName;

    if ([commodityInfo.goodsType isEqualToString:@"0"]) {
        
        self.minAmountLabel.text = [NSString stringWithFormat:@"%ld%@", (long)commodityInfo.batchNumLimit,NSLocalizedString(@"beginGetNum", @"件起批")];

        NSDateFormatter* inputDateFormatter = [[NSDateFormatter alloc]init];
        inputDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate* sendDate = [inputDateFormatter dateFromString:commodityInfo.firstOnsaleTime];

        NSDateFormatter* outputDateFormatter = [[NSDateFormatter alloc]init];
        outputDateFormatter.dateFormat = [NSString stringWithFormat:@"M%@d%@%@",NSLocalizedString(@"month", @"月"),NSLocalizedString(@"day",@"日"),NSLocalizedString(@"update",@"更新")];
        
        self.updateDateLabel.text = [outputDateFormatter stringFromDate:sendDate];
        
       
    }else{//!邮费专拍
    
        self.minAmountLabel.text = @"";
        self.updateDateLabel.text = @"";


    
    }
    
    
    [self.swearImageView sd_setImageWithURL:[NSURL URLWithString:commodityInfo.pictureUrl] placeholderImage:[UIImage imageNamed:@"big_placeHolder"]];

    
    
    if ([commodityInfo isReadable]) {
    
        [self.contentView sendSubviewToBack:self.blurView];
   
    } else {
        
        [self.contentView bringSubviewToFront:self.blurView];
        [self.contentView bringSubviewToFront:self.cornerView];
        self.visibleLevelLabel.text = [NSString stringWithFormat:@"V%d", (int)commodityInfo.readLevel];
    
    }
    
    
}

- (void)startAnimation {
    
    
    if (self.cornerView.isHidden) {
        return;
    }
    
    CGFloat width = CGRectGetWidth(self.cornerView.frame);
    
    self.cornerView.transform = CGAffineTransformMakeTranslation(-width, 0);
    
    [UIView animateWithDuration:0.75f animations:^{
        self.cornerView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.25f animations:^{
//            self.cornerView.transform = CGAffineTransformMakeTranslation(-2, 0);
//        } completion:^(BOOL finished) {
//            self.cornerView.transform = CGAffineTransformMakeTranslation(0, 0);
//        }];
    }];
}

@end
