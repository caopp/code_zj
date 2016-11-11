//
//  SearchGoodsTableViewCell.h
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "GoodsShareDTO.h"
@interface SearchGoodsTableViewCell : CSPBaseTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *shareImgView;
@property (strong, nonatomic) IBOutlet UILabel *shareCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsWillNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsColorLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *updateLabel;
@property (strong, nonatomic) IBOutlet UILabel *commPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *startsLabel;
-(void)loadDTO:(GoodsShareDTO *)dto;
-(void)loadMemberDTO:(GoodsShareDTO *)dto;
@end
