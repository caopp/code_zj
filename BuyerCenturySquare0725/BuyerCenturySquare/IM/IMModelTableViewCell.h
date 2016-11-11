//
//  IMModelTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/9/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMModelTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *lblGoodNo;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodColor;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodPrice;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end
