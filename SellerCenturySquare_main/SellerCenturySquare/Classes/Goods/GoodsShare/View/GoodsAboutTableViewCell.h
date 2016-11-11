//
//  GoodsAboutTableViewCell.h
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "GoodsShareDTO.h"
@interface GoodsAboutTableViewCell : CSPBaseTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsWillNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsColorlabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *deductLabel;
-(void)refigDTO:(GoodsShareDTO *)dto;
@end
