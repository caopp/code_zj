//
//  CSPCounterView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/17/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationWindowViewController.h"

@class CSPCounterView;

@protocol CSPCounterViewDelegate <NSObject>

@optional
- (BOOL)counterView:(CSPCounterView*)counterView couldValueChange:(NSInteger)targetValue;
- (void)counterView:(CSPCounterView*)counterView countChanged:(NSInteger)count;

@end

@interface CSPCounterView : UIView

@property (nonatomic, assign)id<CSPCounterViewDelegate> delegate;
//统计个数
@property (nonatomic, assign)NSInteger count;
//起批数量
@property (nonatomic, assign) NSInteger batchNumLimit;
@property (nonatomic, strong)UITextField* textField;



@end
