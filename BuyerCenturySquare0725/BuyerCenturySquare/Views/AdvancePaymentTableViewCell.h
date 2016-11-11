//
//  AdvancePaymentTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/9.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AdvancePaymentTableViewCellDelegate <NSObject>

-(void)didClickAdvancePaymentPage;

@end


@interface AdvancePaymentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *advancePaymentButton;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak,nonatomic)id<AdvancePaymentTableViewCellDelegate>delegate;

@end
