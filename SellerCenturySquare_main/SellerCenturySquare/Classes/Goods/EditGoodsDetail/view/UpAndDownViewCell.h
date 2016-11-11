//
//  UpAndDownViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetGoodsInfoListDTO.h"

@interface UpAndDownViewCell : UITableViewCell
{
    
    GetGoodsInfoListDTO * editGoodsInfoDTO;
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusDetailLabel;


@property (weak, nonatomic) IBOutlet UIButton *upAndDownBtn;

-(void)configInfo:(GetGoodsInfoListDTO *)goodsInfoDTO;

@end
