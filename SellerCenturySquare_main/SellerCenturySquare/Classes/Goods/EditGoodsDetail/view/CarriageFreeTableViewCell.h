//
//  CarriageFreeTableViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GetGoodsInfoListDTO.h"

@interface CarriageFreeTableViewCell : UITableViewCell
{
    
    GetGoodsInfoListDTO * editGoodsInfoDTO;
    
    
}
//!设置为包邮的按钮
@property (weak, nonatomic) IBOutlet UIButton *setCarriageFressBtn;

@property (weak, nonatomic) IBOutlet UILabel *freeLabel;

@property (weak, nonatomic) IBOutlet UILabel *filterLabel;


-(void)configInfo:(GetGoodsInfoListDTO *)goodsInfoDTO;

@end
