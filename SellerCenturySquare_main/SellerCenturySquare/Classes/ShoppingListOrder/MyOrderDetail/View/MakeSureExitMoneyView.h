//
//  MakeSureExitMoneyView.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeSureExitMoneyView : UIView
@property (nonatomic ,copy)void (^blockMakeSureExitMoneyView)();


- (IBAction)selectMakeSureExitMoneyBtn:(id)sender;

@end
