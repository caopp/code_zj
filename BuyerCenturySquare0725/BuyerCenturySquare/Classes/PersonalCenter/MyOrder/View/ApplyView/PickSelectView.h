//
//  PickSelectView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickSelectView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>


@property(nonatomic,strong)UIPickerView * pickerView;

@property(nonatomic,strong)NSArray * dataArray;

//!是否显示退换货原因
@property(nonatomic,assign)BOOL isShowReason;

//!选中的时候返回  选中要显示的内容，选中要传给服务器的对应值
@property(nonatomic,copy) void (^selectBlock)(NSString * selectTitle,NSNumber * selectNum);

//!刷新 显示退款原因：yes showReason 未收到货：yes
-(void)reloadDataIsShowReason:(BOOL)showReason withNoGetGoods:(BOOL)noGetGoods;

//!确定和取消的点击事件
@property(nonatomic,copy) void (^sureAndCancelBlock)();


@end
