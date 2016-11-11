//
//  SamplePriceViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetGoodsInfoListDTO.h"

@interface SamplePriceViewCell : UITableViewCell
{

    GetGoodsInfoListDTO * editGoodsInfoDTO;

}

@property (weak, nonatomic) IBOutlet UILabel *sampleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UITextField *samplePriceTextField;

@property (weak, nonatomic) IBOutlet UIButton *sampleSelectBtn;

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *bottomFilterLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomFilterHight;

-(void)configData:(GetGoodsInfoListDTO *)goodsInfoDTO;



@end
