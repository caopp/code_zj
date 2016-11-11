//
//  CSPGoodsInfoSubPicsTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"

@interface CSPGoodsInfoSubPicsTableViewCell : CSPBaseTableViewCell
@property (nonatomic,assign) NSString *url;
@property (nonatomic,assign) NSInteger row;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end
