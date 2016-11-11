//
//  IMReferralTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/8/31.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMReferralBtnClickDelegate <NSObject>

- (void)IMReferralBtnClick:(NSString *)goodsNo;

@end

@interface IMReferralTableViewCell : UITableViewCell

@property (nonatomic, assign) id<IMReferralBtnClickDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *lblGoodNo;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodColor;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodPrice;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (nonatomic,strong) NSString *strGoodNo;
@end
