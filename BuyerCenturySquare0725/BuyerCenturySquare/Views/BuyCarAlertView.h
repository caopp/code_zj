//
//  BuyCarAlertView.h
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 16/1/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayout.h"
@protocol BuyCarDelegate <NSObject>

-(void)dismissBuyCarView;

-(void)goBuy;
-(void)goOrder;

@end
@interface BuyCarAlertView : UIView
@property (strong, nonatomic) IBOutlet UIView *alertView;
@property (strong, nonatomic) IBOutlet UILabel *huohaoLab;
@property (strong, nonatomic) IBOutlet UILabel *xianHuoLab;
@property (strong, nonatomic) IBOutlet UILabel *qihuoLab;
@property(nonatomic,assign)id<BuyCarDelegate>delegate;
@property (strong, nonatomic) IBOutlet MyFlowLayout *labelLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *alertHight;

@end
