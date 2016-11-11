//
//  CSPCategoryListView.h
//  DOPNavbarMenuDemo
//
//  Created by skyxfire on 8/5/15.
//  Copyright (c) 2015 weizhou. All rights reserved.
//  商品--商品列表  分类

#import <UIKit/UIKit.h>
#import "CSPMajorMenu.h"
#import "CSPMinorMenu.h"
#import "CommodityClassification.h"// !全部的商品分类
#import "CommodityClassificationDTO.h"

@class CSPCategoryMenu;

@protocol CSPCategoryMenuDelegate <NSObject>

- (void)didShowCategoryMenu:(CSPCategoryMenu *)menu;

- (void)didDismissCategoryMenu:(CSPCategoryMenu *)menu;

- (void)didSelectedCategoryMenu:(CSPCategoryMenu *)menu withStructureNo:(NSString *)structureNum;

@end

@interface CSPCategoryMenu : UIView

@property (copy, nonatomic, readonly) NSArray *items;
@property (assign, nonatomic, readonly) NSInteger maximumNumberInRow;
@property (assign, nonatomic, getter=isOpen) BOOL open;

@property (weak, nonatomic) id <CSPCategoryMenuDelegate> delegate;

- (id)initWithCommodityClassification:(CommodityClassification *)goodClassification parentId:(NSNumber*)parentId;

- (id)initWithItems:(NSArray*)items;

- (void)showInView:(UIView *)view belowSubview:(UIView*)subview;

- (void)dismissWithAnimation:(BOOL)animation;

@end
