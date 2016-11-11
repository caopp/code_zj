//
//  ChangeExitGoodsAndCancelView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeExitGoodsAndCancelView : UIView
//type 0 取消 1 修改
@property (nonatomic ,copy) void (^blockChangeExitGoodsAndCancelView)(NSString *type);

//取消
- (IBAction)selectCancelExitChangeBtn:(id)sender;
//修改
- (IBAction)selectChangeExitChangeBtn:(id)sender;

@end
