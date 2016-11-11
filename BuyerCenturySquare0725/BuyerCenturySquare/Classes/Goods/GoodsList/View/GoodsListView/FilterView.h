//
//  FilterView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/9/12.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterView : UIView<UITextFieldDelegate>

//!全部
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

//!15天内
@property (weak, nonatomic) IBOutlet UIButton *in15DayBtn;

//!15天前
@property (weak, nonatomic) IBOutlet UIButton *after15DayBtn;

//!20天前
@property (weak, nonatomic) IBOutlet UIButton *after20DayBtn;

//!30天前
@property (weak, nonatomic) IBOutlet UIButton *after30DayBtn;

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

//!最低价
@property (weak, nonatomic) IBOutlet UITextField *leastPriceTextField;

@property (weak, nonatomic) IBOutlet UILabel *toLabel;

//!最高价
@property (weak, nonatomic) IBOutlet UITextField *mostPriceTextField;


@property(nonatomic,strong)NSMutableDictionary * upSortDic;

//!确定筛选
@property(nonatomic,copy)void(^sureToSortBlock)(NSDictionary *);



//!初始化数据
-(void)configData:(NSDictionary *)sortDic;


@end
