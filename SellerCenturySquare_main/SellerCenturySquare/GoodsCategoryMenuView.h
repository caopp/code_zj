//
//  GoodsCategoryMenuView.h
//  SellerCenturySquare
//
//  Created by 王剑粟 on 15/9/28.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSegmentView.h"

@class GoodsCategorySecondMenuView;

@protocol CategoryMenuClick <NSObject>

- (void)menuClick:(NSString *)searchId;

@end

@interface GoodsCategoryMenuView : UIView {
    
    float scrolViewContentWidth;
    GoodsCategorySecondMenuView * categorySencondMenuView;
    UIScrollView * scrollView;
}

@property (nonatomic, strong) NSMutableArray * categroyArray;

@property (nonatomic, strong) NSMutableArray * firstLevelNameArray;

@property (nonatomic, strong) NSMutableArray * firstLevelBtnArray;

@property (nonatomic, strong) NSMutableArray * secondLevelNameArray;

@property (assign, nonatomic) id<CategoryMenuClick> delegate;

- (instancetype)initWithArray:(NSMutableArray *)array withParentView:(SMSegmentView *)parentView;

//隐藏和展示的方法
- (void)showOrHidden;

@end