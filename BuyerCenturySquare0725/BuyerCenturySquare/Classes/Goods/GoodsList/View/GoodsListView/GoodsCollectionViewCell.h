//
//  GoodsCollectionViewCell.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/2.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommodityGroupListDTO.h"

@interface GoodsCollectionViewCell : UICollectionViewCell

//!商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

//!商品介绍
@property (weak, nonatomic) IBOutlet UILabel *goodsIntroduceLabel;

//!商品价钱
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

//!起批量
@property (weak, nonatomic) IBOutlet UILabel *minAmountLabel;

//!更新具体日期
@property (weak, nonatomic) IBOutlet UILabel *updateDateLabel;

//!更新时间的view
@property (weak, nonatomic) IBOutlet UIView *cornerView;

//!“天前、天内”
@property (weak, nonatomic) IBOutlet UILabel *dayNumUnitLabel;


//!更新时间
@property (weak, nonatomic) IBOutlet UILabel *dayNumLabel;

//!可查看等级的view
@property (weak, nonatomic) IBOutlet UIView *blurView;

//!可查看等级
@property (weak, nonatomic) IBOutlet UILabel *visibleLevelLabel;

//!推荐
@property (weak, nonatomic) IBOutlet UIImageView *recommendImageView;

@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;


-(void)configData:(Commodity*)goodsCommodity;

- (void)startAnimation;

@end
