//
//  SearchMemberTableViewCell.h
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "GoodsShareDTO.h"
@interface SearchMemberTableViewCell : CSPBaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shareCountLabel;

@property (strong, nonatomic) IBOutlet UIImageView *goodsImgView;
-(void)loadDTO:(GoodsShareDTO *)dto;
@end
