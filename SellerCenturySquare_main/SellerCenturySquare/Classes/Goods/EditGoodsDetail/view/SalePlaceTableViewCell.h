//
//  SalePlaceTableViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GetGoodsInfoListDTO.h"

@interface SalePlaceTableViewCell : UITableViewCell
{
    
    GetGoodsInfoListDTO * _goodsInfoDTO;
    
}

//!是否是零售
@property(nonatomic,assign)BOOL isRetail;

//!"销售渠道"
@property (weak, nonatomic) IBOutlet UILabel *salePlaceLabel;


@property (weak, nonatomic) IBOutlet UIButton *salePlaceBtn;

//!提示信息
@property (weak, nonatomic) IBOutlet UILabel *alerLabel;


-(void)configData:(GetGoodsInfoListDTO *)goodsInfoDTO withIsRetail:(BOOL)isRetail;



@end
