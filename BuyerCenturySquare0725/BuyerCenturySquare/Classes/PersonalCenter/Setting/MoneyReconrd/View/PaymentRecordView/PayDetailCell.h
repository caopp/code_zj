//
//  PayDetailCell.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/14.
//  Copyright © 2016年 pactera. All rights reserved.
//  转账记录查询 cell

#import <UIKit/UIKit.h>

@interface PayDetailCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;


@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;


-(void)configInfo:(NSString *)leftStr withDetailInfo:(NSString *)detailStr;

//!等级提醒行
-(void)configInfo:(NSMutableAttributedString *)leftStr ;


@end
