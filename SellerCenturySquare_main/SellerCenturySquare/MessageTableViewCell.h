//
//  MessageTableViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/15.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

@interface MessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CustomBadge *letterBadge;

//更新badge
- (void)updateBadge:(NSString *)string;


@end
