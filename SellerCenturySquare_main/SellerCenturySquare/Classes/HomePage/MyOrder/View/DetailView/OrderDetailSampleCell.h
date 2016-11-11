//
//  OrderDetailSampleCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/5/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderGoodsItemDTO.h"

@interface OrderDetailSampleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *sampleImageView;

@property (weak, nonatomic) IBOutlet UILabel *sampleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sampleNameLabel;


@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *filterLabel;


-(void)configData:(orderGoodsItemDTO * )orderGoodsItemDTO;


@end
