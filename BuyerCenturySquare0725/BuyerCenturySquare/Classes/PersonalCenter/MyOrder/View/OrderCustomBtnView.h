//
//  OrderCustomBtnView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/6/3.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCustomBtnView : UIView

@property (nonatomic ,copy) void (^blockOrderCustomBtnView)();

- (IBAction)selectCustomBtn:(id)sender;
- (IBAction)selectlateCustomBtn:(id)sender;


@end
