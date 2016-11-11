//
//  MerchantAndGoodSelectView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantAndGoodSelectView : UIView
{

    NSMutableArray * dataArray;


}
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;

@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

//!第一个按钮旁边的分割线
@property (weak, nonatomic) IBOutlet UILabel *firstRightLabel;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;


//!改变自身的高度 参数：是否点击了按钮（如果点击按钮就调到搜索界面）
@property(nonatomic,copy)void(^changHightBlock)(BOOL);

//!放置数据，如果是搜索商家，就传入yes
-(void)setDataisFromMerchant:(BOOL)isSearchMerchant;

//!第二个按钮的点击事件调用的方法（为了方便外面能调用）
-(void)secondBtnClick;



@end
