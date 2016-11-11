//
//  GoodsCategoryMenuView.h
//  SellerCenturySquare
//
//  Created by 王剑粟 on 15/9/28.
//  Copyright © 2015年 pactera. All rights reserved.
//  !商家详情  商品分类

#import <UIKit/UIKit.h>
#import "SMSegmentView.h"

@class GoodsCategorySecondMenuView;

@protocol CategoryMenuClick <NSObject>

- (void)menuClick:(NSString *)searchId;

@end

@interface GoodsCategoryMenuView : UIView {
    
    float scrolViewContentWidth;
    GoodsCategorySecondMenuView * categorySencondMenuView;// !二级菜单
    UIScrollView * scrollView;
}

@property (nonatomic, strong) NSMutableArray * categroyArray;

@property (nonatomic, strong) NSMutableArray * firstLevelNameArray;

@property (nonatomic, strong) NSMutableArray * firstLevelBtnArray;

@property (nonatomic, strong) NSMutableArray * secondLevelNameArray;

@property (nonatomic,strong) NSMutableArray *thirdLevelNameArray;//!三级分类

@property (assign, nonatomic) id<CategoryMenuClick> delegate;


- (instancetype)initWithArray:(NSMutableArray *)array withParentView:(UIView *)parentView;

//隐藏和展示的方法
- (void)showOrHidden;

@end