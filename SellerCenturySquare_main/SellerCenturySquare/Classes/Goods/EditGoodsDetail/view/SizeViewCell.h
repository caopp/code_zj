//
//  SizeViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//  商品尺寸的cell

#import <UIKit/UIKit.h>
#import "GetGoodsInfoListDTO.h"
#import "GoodsInfoDTO.h"

@interface SizeViewCell : UITableViewCell
{

    GetGoodsInfoListDTO * cellGoodsInfoDTO;

    //!分割线
    UILabel * filterLabel;
    
}

@property(nonatomic,weak)UILabel *sizeLabel;

@property(nonatomic,assign)float cellHight;//!自身的高度

-(void)configData:(GetGoodsInfoListDTO *)goodsInfoDTO;

@end
