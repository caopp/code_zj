//
//  IMOrderTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/8/31.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblGoodNo;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodColor;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodPrice;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UIView *countView;

@property (nonatomic, strong) NSString * jsonSku;

@end
