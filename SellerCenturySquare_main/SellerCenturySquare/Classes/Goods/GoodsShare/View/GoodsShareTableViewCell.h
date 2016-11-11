//
//  GoodsShareTableViewCell.h
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/7.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsShareDTO.h"
#import "CSPBaseTableViewCell.h"
@interface GoodsShareTableViewCell : CSPBaseTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userHeadView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *imageShareCount;
@property (strong, nonatomic) IBOutlet UILabel *shareImgState;
@property (strong, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsNoLabel;

@property (strong, nonatomic) IBOutlet UILabel *goodsColorLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsDeductLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
-(void)configDto:(GoodsShareDTO *)dto;
@end
