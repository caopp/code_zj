//
//  MyOrderPromptView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/4/6.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderAddDTO.h"
@protocol MyOrderPromptDelegate <NSObject>

- (void)MyOrderPromptTableViewHeight:(CGFloat) height;
- (void)myOrderPromptClearView:(UIView *)view;
- (void)myOrderPromptPayMoney:(NSArray*)moneyArr view:(UIView *)view;

@end

@interface MyOrderPromptView : UIView

@property (nonatomic ,strong)OrderAddDTO *orderDto;

@property (nonatomic ,strong)OrderAddDTO *recordOrderDto;

@property (nonatomic ,assign) id<MyOrderPromptDelegate>delegate;




@end

