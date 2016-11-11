//
//  CenterNormalShopMessageTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderParentTableViewCell.h"

@interface CenterNormalShopMessageTableViewCell : MyOrderParentTableViewCell
/**
 * 商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPhotoImage;
/**
 *  商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
/**
 *  商品颜色
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsColorLab;
/**
 *  商品尺码
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsSizeLab;
/**
 *  商品单价
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLab;
/**
 *  商品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNumbLab;


@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIView *sizesView;


@end
