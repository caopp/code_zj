//
//  CPSMyOrderTopView.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

@interface CPSMyOrderTopView : CSPBaseCustomView <UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic, strong) UIScrollView *  btnScrollView;

@property (nonatomic, assign) BOOL isScroll;

@property (nonatomic,copy)void (^chooseOrderTypeBlock)(NSInteger integer);

- (void)initButton;

- (void)showButtonWithIndex:(NSInteger)index;

- (void)removeAllSubviews;

- (void)reloadTitleWithTitle:(NSString *)title integer:(NSInteger)integer;

- (instancetype)initWithScrollView:(CGRect)frame;

@end
