//
//  GoodsCollectionViewCell.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/2.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "CSPUtils.h"


@implementation GoodsCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFill; // 这是整个view会被图片填满，图片比例不变 ，这样图片显示就会大于view
    
    self.goodsImageView.clipsToBounds = YES;

    
}

-(void)configData:(Commodity*)goodsCommodity{

    //!更新时间 上架天数0代表15天内，15代表15天前，20代表20天前
    if (goodsCommodity.dayNum == 0) {
        
        self.dayNumLabel.text = [NSString stringWithFormat:@"%ld",(long)goodsCommodity.withinDays];
        self.dayNumUnitLabel.text = NSLocalizedString(@"inDay", @"天\n内");
        
    }else{
        
        self.dayNumUnitLabel.text = NSLocalizedString(@"outDay", @"天\n前");
        self.dayNumLabel.text = [NSString stringWithFormat:@"%ld", goodsCommodity.dayNum];
        
    }

    //!价钱
//    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    
    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];

    NSString* priceValue = [CSPUtils isRoundNumber:goodsCommodity.price] ? [NSString stringWithFormat:@"%ld", (long)goodsCommodity.price] : [NSString stringWithFormat:@"%.02f", goodsCommodity.price];
    
    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:priceValue attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:22]}];
    
    [priceString appendAttributedString:priceValueString];
    
    self.goodsPriceLabel.attributedText = priceString;

    //!名称

    self.goodsIntroduceLabel.text = goodsCommodity.goodsName;
    
    
    //!显示的图片
    [self.goodsImageView setImage:[UIImage imageNamed:@"middle_placeHolder"]];
    
    
    //!起批价钱、更新时间
    if ([goodsCommodity.goodsType isEqualToString:@"0"]) {
        
        self.minAmountLabel.text = [NSString stringWithFormat:@"%ld%@", (long)goodsCommodity.batchNumLimit,NSLocalizedString(@"beginGetNum", @"件起批")];
        
        NSDateFormatter* inputDateFormatter = [[NSDateFormatter alloc]init];
        inputDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate* sendDate = [inputDateFormatter dateFromString:goodsCommodity.firstOnsaleTime];
        
        NSDateFormatter* outputDateFormatter = [[NSDateFormatter alloc]init];
        outputDateFormatter.dateFormat = [NSString stringWithFormat:@"M%@d%@%@",NSLocalizedString(@"month", @"月"),NSLocalizedString(@"day",@"日"),NSLocalizedString(@"update",@"更新")];
        
        self.updateDateLabel.text = [outputDateFormatter stringFromDate:sendDate];
        
        //!显示的图片
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsCommodity.pictureUrl] placeholderImage:[UIImage imageNamed:@"middle_placeHolder"]];
        
        
        
    }else{//!邮费专拍
        
        self.minAmountLabel.text = @"";
        self.updateDateLabel.text = @"";
        
        //!显示的图片
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsCommodity.pictureUrl] placeholderImage:[UIImage imageNamed:@"middle_placeHolder"]];
        

    }
    
    
    //!是否可查看  可看或者是邮费专拍的时候，将蒙层移到后面
    if ([goodsCommodity isReadable] || [goodsCommodity.goodsType isEqualToString:@"1"]) {
        
        [self.contentView sendSubviewToBack:self.blurView];
    
        
    } else {
        
        [self.contentView bringSubviewToFront:self.blurView];
        [self.contentView bringSubviewToFront:self.cornerView];
        
        self.visibleLevelLabel.text = [NSString stringWithFormat:@"V%d", (int)goodsCommodity.readLevel];
        
        //!推荐
        [self.contentView bringSubviewToFront:self.recommendImageView];
        [self.contentView bringSubviewToFront:self.recommendLabel];
        
    }
    
    //!是否推荐
    self.recommendImageView.hidden = !goodsCommodity.recommendFlag;
    self.recommendLabel.hidden = !goodsCommodity.recommendFlag;
    
    
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
       
        
    }];
}

@end
