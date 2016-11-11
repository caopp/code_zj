//
//  CSPInfoTableViewCell.h
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/20.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "GoodsMoreDTO.h"
@interface CSPInfoTableViewCell : CSPBaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
-(void)loadDTO:(GoodsMoreDTO *)dto;
@end
