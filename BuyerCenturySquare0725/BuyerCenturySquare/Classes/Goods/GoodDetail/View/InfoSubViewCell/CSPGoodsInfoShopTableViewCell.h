//
//  CSPGoodsInfoShopTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  !点击进入商店详情的cell

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"
@interface CSPGoodsInfoShopTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopL;
@property (strong, nonatomic) IBOutlet UILabel *termL;
@property (strong, nonatomic)NSString *msg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;
@property (nonatomic,strong) NSMutableAttributedString *shopName;
@end
