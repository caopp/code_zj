//
//  JustChangeGoodsDealView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JustChangeGoodsDealView : UIView
//type 0 客服 1查看退/换货 2 确认收货
@property (nonatomic ,copy)void (^blockJustChangeGoodsDealView)(NSInteger type);
- (IBAction)selectExitMoneyBtn:(id)sender;

- (IBAction)selectCustomerServiceBtn:(id)sender;
- (IBAction)selectMakeSureAcceptBtn:(id)sender;


@end
