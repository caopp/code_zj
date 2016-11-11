//
//  ScoreTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/4.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textL;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

//更新score
- (void)setScore:(NSString*)score;
@end
