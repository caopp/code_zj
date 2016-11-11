//
//  GoodReferencerTableViewCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodReferencerTableViewCell : UITableViewCell
//图片个数
@property (weak, nonatomic) IBOutlet UILabel *picNumLabel;
//零售价
@property (weak, nonatomic) IBOutlet UILabel *retailPriceLabel;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
//状态
@property (weak, nonatomic) IBOutlet UILabel *goodsStatusLabel;
//货号
@property (weak, nonatomic) IBOutlet UILabel *goodsWillNoLabel;
//商品颜色
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
//图片链接url
@property (weak, nonatomic) IBOutlet UIImageView *imgUrlImage;
// 窗口图设置
@property (weak, nonatomic) IBOutlet UILabel *windowSetLabel;
//详情图设置
@property (weak, nonatomic) IBOutlet UILabel *detailSetLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;




@end
