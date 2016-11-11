//
//  LetterTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

@interface LetterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CustomBadge *letterBadge;
//更新badge
- (void)updateBadge:(NSString *)string;
@end
