//
//  GoodsMoreTableViewCell.h
//  SellerCenturySquare
//
//  Created by caopenpen on 16/8/1.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "GoodsShareDTO.h"

@interface GoodsMoreTableViewCell : CSPBaseTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userHeadView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *imageShareCount;
@property (strong, nonatomic) IBOutlet UILabel *shareImgState;
@property (strong, nonatomic) IBOutlet UILabel *goodsNoLabel;

@property (strong, nonatomic) IBOutlet UILabel *goodsColorLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsDeductLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
-(void)configDto:(GoodsShareDTO *)dto;
@end
