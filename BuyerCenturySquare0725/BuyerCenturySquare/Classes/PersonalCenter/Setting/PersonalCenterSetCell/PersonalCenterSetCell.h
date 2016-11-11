//
//  PersonalCenterSetCell.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/10.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  PersonlCeterSetSingle;

@interface PersonalCenterSetCell : UITableViewCell

@property (strong,nonatomic)UILabel *lineLabel;
@property (strong,nonatomic)PersonlCeterSetSingle *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
