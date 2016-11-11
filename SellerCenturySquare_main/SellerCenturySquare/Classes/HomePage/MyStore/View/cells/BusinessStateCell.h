//
//  BusinessStateCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/11/20.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

@interface BusinessStateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet CustomBadge *levelBadgeLabel;

@property (weak, nonatomic) IBOutlet UILabel *businessStateL;

@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

// !点击等级的时候返回的

@property(nonatomic,copy) void(^levelBlock)();



- (void)setLevelString:(NSString*)level;
- (void)updateBusinessState:(BOOL)stateOn;


@end
