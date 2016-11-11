//
//  WeightViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetGoodsInfoListDTO.h"

@interface WeightViewCell : UITableViewCell
{
    GetGoodsInfoListDTO * goodsInfoDTO;

}

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@property (weak, nonatomic) IBOutlet UITextField *weightTextField;

@property (weak, nonatomic) IBOutlet UILabel *kgLabel;

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *bottomFilterLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomFilterLabelHight;




-(void)configData:(GetGoodsInfoListDTO *)goodDTO;



@end
