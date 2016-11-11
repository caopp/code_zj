//
//  BeginViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetGoodsInfoListDTO.h"

@interface BeginViewCell : UITableViewCell
{

    GetGoodsInfoListDTO * editGoodsInfoDTO;


}

@property (weak, nonatomic) IBOutlet UILabel *beginLabel;

@property (weak, nonatomic) IBOutlet UITextField *beiginTextField;

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *bottomFilterLabel;

//!分割线高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomFilterLabelHight;


-(void)configInfo:(GetGoodsInfoListDTO *)goodsInfoDTO;


@end
