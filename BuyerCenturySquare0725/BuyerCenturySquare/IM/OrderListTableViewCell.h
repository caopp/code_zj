//
//  OrderListTableViewCell.h
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayout.h"
#import "ECMessage.h"
@interface OrderListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet MyFlowLayout *layOutView;
-(void)loadMessage:(ECMessage *)message;
@end
