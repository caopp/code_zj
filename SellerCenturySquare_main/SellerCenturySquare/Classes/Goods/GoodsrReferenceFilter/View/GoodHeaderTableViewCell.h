//
//  GoodHeaderTableViewCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodHeaderTableViewCell : UITableViewCell

//零售价
@property (weak, nonatomic) IBOutlet UILabel *retailPriceLabel;
//名称
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
//默认图
@property (weak, nonatomic) IBOutlet UIImageView *imgUrlLabel;
//商品货号
@property (weak, nonatomic) IBOutlet UILabel *goodsWillNoLabel;

//货物颜色
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
//货物状态
@property (weak, nonatomic) IBOutlet UILabel *goodsStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end
