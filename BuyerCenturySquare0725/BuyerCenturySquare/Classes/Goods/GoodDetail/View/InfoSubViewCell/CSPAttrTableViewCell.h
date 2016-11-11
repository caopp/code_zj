//
//  CSPAttrTableViewCell.h
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "AttrListDTO.h"
@interface CSPAttrTableViewCell : CSPBaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
-(void)setAttrListDTO:(AttrListDTO *)attrDto;
@end
