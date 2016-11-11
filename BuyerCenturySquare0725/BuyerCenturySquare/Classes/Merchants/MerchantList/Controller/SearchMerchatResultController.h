//
//  SearchMerchatResultController.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/22.
//  Copyright © 2016年 pactera. All rights reserved.
// !搜索商家 结果页

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface SearchMerchatResultController : BaseViewController


@property(nonatomic,assign)BOOL isSearchMerchant;//!搜索的是否是商家

//!筛选 侧滑菜单 进行筛选进入的 
@property(nonatomic,assign)BOOL isFilter;


//! 1 和 2只能查一个
//!1、查询的内容（搜索）
@property(nonatomic,copy)NSString * searchContent;

//!2、分类的id(筛选)
@property(nonatomic,copy)NSString * categoryNo;
@property(nonatomic,copy)NSString * categoryName;

//!返回搜索界面的时候告诉搜索的是否是商家
@property(nonatomic,copy) void(^isSearchMerchantBlock)(BOOL);



@end
