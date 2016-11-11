//
//  MakeSureExitMoneyAndChangeGoodsView.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeSureExitMoneyAndChangeGoodsView : UIView

@property (nonatomic ,copy) void (^blockMakeSureExitMoneyAndChangeGoodsView)();
- (IBAction)selectMakeSureExitMoneyChangeGoodsBtn:(id)sender;

@end
