//
//  CSPContentTableViewCell.h
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/21.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import"CSPBaseTableViewCell.h"
#import "GoodsMoreDTO.h"
@interface CSPContentTableViewCell : CSPBaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
-(void)loadDTO:(GoodsMoreDTO *)dto;
@end
