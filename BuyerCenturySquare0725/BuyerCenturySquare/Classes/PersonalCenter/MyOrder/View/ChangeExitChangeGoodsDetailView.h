//
//  ChangeExitChangeGoodsDetailView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeExitChangeGoodsDetailView : UIView

@property (nonatomic ,copy) void (^blockChangeExitChangeGoodsDetailView)();
- (IBAction)selectChangeExitChangeBtn:(id)sender;

@end
