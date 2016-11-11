//
//  IMCollectOrderTableViewCell.h
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayout.h"
#import "ECMessage.h"
@interface IMCollectOrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet MyFlowLayout *layOutView;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
-(void)loadMessage:(ECMessage *)message;
@end
