//
//  RecordTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/20.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealFlowModel.h"
@interface RecordTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *gradeaLabel;
@property (strong, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
-(void)setModelParameters:(DealFlowModel *)parameters;

@end
