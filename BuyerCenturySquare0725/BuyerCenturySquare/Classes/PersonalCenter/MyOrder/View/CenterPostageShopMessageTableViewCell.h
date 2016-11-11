//
//  CenterPostageShopMessageTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderParentTableViewCell.h"

@interface CenterPostageShopMessageTableViewCell : MyOrderParentTableViewCell

/**
 *  商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPhotoImage;
/**
 *  商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
/**
 *  商品单价
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLab;
/**
 *  商品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNumbLab;
//分割线
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
