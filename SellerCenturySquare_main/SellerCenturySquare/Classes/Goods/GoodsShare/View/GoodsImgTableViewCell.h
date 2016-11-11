//
//  GoodsImgTableViewCell.h
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "GoodsSharePicDTO.h"
@interface GoodsImgTableViewCell : CSPBaseTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *goodsImgView;
-(void)refigDTO:(GoodsSharePicDTO *)dto;

@end
