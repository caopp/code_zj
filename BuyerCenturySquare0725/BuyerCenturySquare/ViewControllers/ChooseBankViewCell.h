//
//  ChooseBankViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/20.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChooseBankViewCell;
@protocol ChooseBankViewCellDelegate <NSObject>
- (void)chooseBankCell:(ChooseBankViewCell *)cell;


@end

@interface ChooseBankViewCell : UITableViewCell

@property (nonatomic ,assign) id<ChooseBankViewCellDelegate>delegate;

- (void)showSeleAndBankNameDic:(NSDictionary *)dic;
@end


