//
//  UUBtnView.h
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/8/26.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUBtnView;

@protocol UUBtnViewDelegate <NSObject>


- (void)UUBtnViewBtnClick:(UUBtnView *)btnView btnIndex:(NSInteger)index;

@end

@interface UUBtnView : UIView

@property (assign, nonatomic) id <UUBtnViewDelegate> delegate;
@property (nonatomic,strong)UIView *shopPoint;
@end
