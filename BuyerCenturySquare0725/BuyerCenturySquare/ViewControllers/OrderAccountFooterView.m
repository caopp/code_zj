//
//  OrderAccountFooterView.m
//  CustomerCenturySquare
//
//  Created by 陈光 on 16/6/23.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "OrderAccountFooterView.h"

@implementation OrderAccountFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib
{
    self.textField.backgroundColor = [UIColor clearColor];
    
    
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.userInteractionEnabled = YES;
    self.textField.inputView = self.pickerView;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = [UIColor colorWithHexValue:0xE2E1E2 alpha:1];
    self.pickerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 261);
    

    
    self.textField.tintColor=[UIColor clearColor];
    
    self.textField.inputAccessoryView = [self addToolbar];
    self.textField.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height-261, [UIScreen mainScreen].bounds.size.width, 261);
    

}

#pragma mark - UIPickViewDelegate&&UIPickViewDataSource
//该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// 该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.recrodGoodsAccountListDto.delieveryListArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    DelieveryListDTO *delieveryDto = self.recrodGoodsAccountListDto.delieveryListArr[row];
    NSString *name = [NSString stringWithFormat:@"%@（￥%.2f）",delieveryDto.templateName,delieveryDto.delieveryFee.doubleValue];
    
    return name;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"didSelectRow = %lu",row);
    
    DelieveryListDTO *delieveryListDto = self.recrodGoodsAccountListDto.delieveryListArr[row];
    self.delieveryListDto = delieveryListDto;
    
}

//键盘顶部添加完成按钮
- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor colorWithHexValue:0xF0F0F0 alpha:1];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.userInteractionEnabled = YES;
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(toolBarDoneClick) forControlEvents:UIControlEventTouchUpInside];
    
    finishBtn.frame = CGRectMake(0, 0, 70, 44);
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(toolBarCanelClick) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn.frame = CGRectMake(0, 0, 70, 44);
    
    
    
    [finishBtn setTitleColor:[UIColor colorWithHexValue:0x007AFF alpha:1] forState:UIControlStateNormal];
    
    [cancelBtn setTitleColor:[UIColor colorWithHexValue:0x007AFF alpha:1] forState:UIControlStateNormal];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
    UIBarButtonItem *cancelBar = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    toolbar.items = @[cancelBar,space, bar];
    
    return toolbar;
}


-(void)toolBarCanelClick{
    
    [self.textField resignFirstResponder];
    
    
}

-(void)toolBarDoneClick{
    
    
        self.pickerView.showsSelectionIndicator = YES;
    
    if (self.blockOrderAccountFooterSelectData) {
        self.blockOrderAccountFooterSelectData(self.delieveryListDto);
    }
    
    [self.textField resignFirstResponder];

}


//赋值
- (void)orderAccountFootCartConfirmMerchant:(CartConfirmMerchant *)cartConfirmMerchant;
{
    
    
    
    self.chargesLab.text = [NSString stringWithFormat:@"￥%.2f",cartConfirmMerchant.delieveryFee.doubleValue];
        
        
        
    
        
    
    
    
    NSString *priceStr = [NSString stringWithFormat:@"￥%.2f",cartConfirmMerchant.orderTotalPrice.doubleValue];
    NSMutableAttributedString *AttributedPirceStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    
    
    
    [AttributedPirceStr addAttribute:NSFontAttributeName
     
                          value: [UIFont systemFontOfSize:12.0]
     
                          range:NSMakeRange(0,1)] ;
    
    
    self.goodsTotalPriceLab.attributedText = AttributedPirceStr;

    
    
    
    
    NSString *totalStr =[NSString stringWithFormat:@"共 %lu 件",cartConfirmMerchant.totalQuantity.integerValue];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
    

    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor blackColor]
     
                          range:NSMakeRange(1, totalStr.length-2)];
    

    self.goodsTotalNumbLab.attributedText = AttributedStr;
    
    if (cartConfirmMerchant.delieveryListArr.count>1) {
        self. textField.enabled = YES;
    }else
    {
        self.textField.enabled = NO;
        
    }
    
    if (cartConfirmMerchant) {
        self.recrodGoodsAccountListDto = cartConfirmMerchant;
        if (cartConfirmMerchant.delieveryListArr.count>0) {
            NSArray *arr = cartConfirmMerchant.delieveryListArr;
            for (int i = 0; i<arr.count; i++) {
                DelieveryListDTO *delieveryDto = arr[i];
                if (delieveryDto.isSeclect.integerValue == 1) {
                    
                    DelieveryListDTO *delieveryListDto = self.recrodGoodsAccountListDto.delieveryListArr[i];

                    self.delieveryListDto = delieveryListDto;
                    [self.pickerView selectRow:i inComponent:0 animated:YES];

                    
                }
            }
            
        }
        
        
        
        [self.pickerView reloadAllComponents];
        
        
    }
}

@end
