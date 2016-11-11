//
//  ApplyTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/5/10.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplyTableViewCellDelegate <NSObject>

-(void)jumpApplyPage;

@end


@interface ApplyTableViewCell : UITableViewCell

@property (weak,nonatomic)id<ApplyTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *descritionLabel;

@property (weak, nonatomic) IBOutlet UIView *groundView;

@property (weak, nonatomic) IBOutlet UIButton *applyButton;

- (IBAction)didClickButtonAction:(id)sender;

@end
