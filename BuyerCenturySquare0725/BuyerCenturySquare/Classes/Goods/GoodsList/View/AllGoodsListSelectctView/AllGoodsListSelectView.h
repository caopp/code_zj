//
//  AllGoodsListSelectView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/4.
//  Copyright © 2016年 pactera. All rights reserved.
// !全部商品： 全部、我的等级可看 切换的view

#import <UIKit/UIKit.h>

@interface AllGoodsListSelectView : UIView

//!全部
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

//!我的等级可看
@property (weak, nonatomic) IBOutlet UIButton *canBrowserBtn;


//!选中“全部”
-(void)changeAllBtnSelected;

//!选中“我的等级可看”
-(void)changeCanBrowserBtnSelected;


@property(nonatomic,copy)void(^allBtnClickBlock)();

@property(nonatomic,copy)void(^canBrowserBtnClickBlock)();


@end
