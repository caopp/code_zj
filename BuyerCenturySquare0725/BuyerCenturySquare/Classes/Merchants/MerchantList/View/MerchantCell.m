//
//  MerchantCell.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/1.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MerchantCell.h"
#import "UIImageView+WebCache.h"

@implementation MerchantCell

- (void)awakeFromNib {
    // Initialization code

    self.merchantTypeLabel.layer.cornerRadius = 2;
    self.merchantTypeLabel.layer.masksToBounds = YES;

    self.showImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.showImageView.clipsToBounds = YES;

    //!商家收藏按钮不同状态的图片显示
    [self.collectBtn setImage:[UIImage imageNamed:@"merchant_collect"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"merchant_collectSelected"] forState:UIControlStateSelected];
    
    //!商家名称： 正常情况下的
    [self.merchantNameLabel setFont:[UIFont systemFontOfSize:25]];
    

}

-(void)configInfo:(MerchantListDetailsDTO *) merListDto{

    //!推荐
    self.recommentView.hidden = YES;
    self.recommentLabel.text = @"";
    
    if ([merListDto.flag isEqualToString:@"1"]) {//!推荐
        
        self.recommentView.hidden = NO;
        self.recommentLabel.text = NSLocalizedString(@"recommend", @"推荐");
        
        
    }else if ([merListDto.flag isEqualToString:@"2"]){//!上新
        
        self.recommentView.hidden = NO;
        self.recommentLabel.text = NSLocalizedString(@"new", @"上新");

    
    }


    
    //!图片
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:merListDto.pictureUrl] placeholderImage:[UIImage imageNamed:@"big_placeHolder"]];

    //!档口号
    self.merchantNumLabel.text = merListDto.stallNo;
    
    //!店铺名称
    self.merchantNameLabel.text = merListDto.merchantName;
    

    //!店铺类型
    self.merchantTypeLabel.text = merListDto.categoryName;
    
    //!商品数量
    self.goodsNumLabel.text =[NSString stringWithFormat:@"%d", merListDto.goodsNum.intValue];
    
    //!商家状态
 
    
    if ([merListDto.operateStatus isEqualToString:@"1"]) {//!歇业
        
        self.outBusinessView.hidden = NO;
        
        self.outBussinessNameLabel.text = merListDto.merchantName;//!歇业的商家名称
        
        //!歇业时间
        NSDateFormatter* inputDateFormatter = [[NSDateFormatter alloc]init];
        inputDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate* startDate = [inputDateFormatter dateFromString:merListDto.closeStartTime];
        NSDate* endDate = [inputDateFormatter dateFromString:merListDto.closeEndTime];
        
        NSDateFormatter* outputDateFormatter = [[NSDateFormatter alloc]init];
        outputDateFormatter.dateFormat = @"yyyy/MM/dd";
        // !歇业时间段
        self.outBussinessTimeLabel.text = [NSString stringWithFormat:@"%@ ~ %@", [outputDateFormatter stringFromDate:startDate], [outputDateFormatter stringFromDate:endDate]];
        
        
        self.merchantNameLabel.hidden = YES;
        self.merchantTypeLabel.hidden = YES;
        
        self.merchantStoreImageView.hidden = YES;
        self.merchantNumLabel.hidden = YES;
        
        self.goodsNumImageView.hidden = YES;
        self.goodsNumLabel.hidden = YES;
        
        
    }else{
        
        //!歇业提示view默认隐藏
        self.outBusinessView.hidden = YES;
        
        
        self.merchantNameLabel.hidden = NO;
        self.merchantTypeLabel.hidden = NO;
        
        self.merchantStoreImageView.hidden = NO;
        self.merchantNumLabel.hidden = NO;
        
        self.goodsNumImageView.hidden = NO;
        self.goodsNumLabel.hidden = NO;
    
        
    
    }
    
    self.collectBtn.selected = NO;

    //!是否收藏
    if ([merListDto.isFavorite isEqualToString:@"0"]) {//!收藏
        
        self.collectBtn.selected = YES;
        
    }else{//!未收藏
    
        self.collectBtn.selected = NO;
    
    }
    
    
    detailDto = merListDto;//!这个值只是为了改变透明度的时候看是哪个商家
    
    
}


//!收藏
- (IBAction)collectBtnClick:(id)sender {
    
    
    if (self.collectBtnClock) {
        
        self.collectBtnClock();
    
    }
    
    
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    
    [super applyLayoutAttributes:layoutAttributes];
    
    CGFloat RPSlidingCellFeatureHeight = SCREEN_WIDTH;//!顶部cell的高度
    
    CGFloat RPSlidingCellCollapsedHeight = SCREEN_WIDTH *0.4;//!非顶部cell的高度
    
    //! 顶部cell的高度 - 非顶部cell的高度
    CGFloat featureNormaHeightDifference = RPSlidingCellFeatureHeight - RPSlidingCellCollapsedHeight;
    
    //! 顶部cell的高度 - 当前cell的高度
    
    // how much its grown from normal to feature
    CGFloat amountGrown = RPSlidingCellFeatureHeight - self.frame.size.height;
    
    // percent of growth from normal to feature
    CGFloat percentOfGrowth = 1 - (amountGrown / featureNormaHeightDifference);
    
    percentOfGrowth = sin(percentOfGrowth * M_PI_2);//!在1和0之间波动(顶部的是1，非顶部的是0)
    
    if (percentOfGrowth < 0 ) {
        
         percentOfGrowth = 0;
        
    }
    
    //!商家名称
    //!位置
    self.nameCenterY.constant = - percentOfGrowth* 40;
    
    //!字体大小
    CGFloat nameFont = 25 - ((1 - percentOfGrowth) * (25 - 20));
    
    [self.merchantNameLabel setFont:[UIFont systemFontOfSize:nameFont]];

    //!字体颜色
    if (percentOfGrowth<0) {//!非顶部的时候
        
        [self.merchantNameLabel setTextColor:[UIColor colorWithHexValue:0xffffff alpha:0.7]];
        self.merchantNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.merchantNameLabel.layer.shadowOffset = CGSizeMake(1, 1);
        
        self.merchantNameLabel.layer.shadowOpacity = 0.8;
        
        self.merchantNameLabel.layer.shadowRadius = 1.5f;
        
    }else{//!顶部的时候
    
        
        [self.merchantNameLabel setTextColor:[UIColor colorWithHexValue:0xffffff alpha:1]];
        
        
        //!商家名称的投影
        self.merchantNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;

        self.merchantNameLabel.layer.shadowOffset = CGSizeMake(1, 1);

        self.merchantNameLabel.layer.shadowOpacity = 0.8;
        
        self.merchantNameLabel.layer.shadowRadius = 1.5f;
        
        //!类型的投影
        self.merchantTypeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.merchantTypeLabel.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        
        self.merchantTypeLabel.layer.shadowOpacity = 0.8;
        
        self.merchantTypeLabel.layer.shadowRadius = 1;
        
        //!档口号前面图片的投影
        self.merchantStoreImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.merchantStoreImageView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        
        self.merchantStoreImageView.layer.shadowOpacity = 0.8;
        
        self.merchantStoreImageView.layer.shadowRadius = 1;
        
        //!档口号的投影
        self.merchantNumLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.merchantNumLabel.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        
        self.merchantNumLabel.layer.shadowOpacity = 0.8;
        
        self.merchantNumLabel.layer.shadowRadius = 1;
        
        //!商品数量前面图片的投影
        self.goodsNumImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.goodsNumImageView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        
        self.goodsNumImageView.layer.shadowOpacity = 0.8;
        
        self.goodsNumImageView.layer.shadowRadius = 1;

        
        //!商家商品数量的阴影
        self.goodsNumLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.goodsNumLabel.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        
        self.goodsNumLabel.layer.shadowOpacity = 0.8;
        
        self.goodsNumLabel.layer.shadowRadius = 1;

        
        
        
    }
    
    //!文字透明度
    
    self.merchantTypeLabel.alpha = percentOfGrowth;
    
    self.merchantStoreImageView.alpha = percentOfGrowth;
    self.merchantNumLabel.alpha = percentOfGrowth;
    
    self.goodsNumImageView.alpha = percentOfGrowth;
    self.goodsNumLabel.alpha = percentOfGrowth;
    
    self.collectBtn.alpha = percentOfGrowth;
    
    CGFloat merchantNamerAlpha = percentOfGrowth * 0.3 + 0.7;//!透明度从0.7---1（顶部的是1，第二个是0.7）
    
    self.merchantNameLabel.alpha = merchantNamerAlpha;
    
    
    //!蒙层的透明度在0.5---0.05之间浮动；
    CGFloat grayAlpha = 0.5 - (percentOfGrowth * (0.5 - 0.05));
    self.garyView.alpha = grayAlpha;
    
    
    
}

@end
