//
//  CSPGoodsInfoTextTableViewCell.h
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 16/1/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"

@interface CSPGoodsInfoTextTableViewCell : CSPBaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property(strong,nonatomic) NSString *infoString;
@end
