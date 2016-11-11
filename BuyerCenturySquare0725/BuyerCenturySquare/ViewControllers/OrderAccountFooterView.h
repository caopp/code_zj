//
//  OrderAccountFooterView.h
//  CustomerCenturySquare
//
//  Created by 陈光 on 16/6/23.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartListConfirmDTO.h"

@interface OrderAccountFooterView : UIView<UIPickerViewDelegate ,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic ,strong)UIPickerView *pickerView;

//选中的list列表
@property(nonatomic ,copy)void (^blockOrderAccountFooterSelectData)(DelieveryListDTO*deliverListDto );
//运费
@property (weak, nonatomic) IBOutlet UILabel *chargesLab;
//商品的总件数
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalNumbLab;
//小计钱数
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalPriceLab;

//记录列表
@property (nonatomic ,strong) CartConfirmMerchant *recrodGoodsAccountListDto;

//block返回的数据
@property (nonatomic ,strong)DelieveryListDTO *delieveryListDto;



- (void)orderAccountFootCartConfirmMerchant:(CartConfirmMerchant *)cartConfirmMerchant;



@end
