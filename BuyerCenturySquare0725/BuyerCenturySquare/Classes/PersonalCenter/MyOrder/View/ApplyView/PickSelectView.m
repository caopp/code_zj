//
//  PickSelectView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PickSelectView.h"

@implementation PickSelectView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];

    if (self) {
                
        //!创建控件
        [self makeUI];
        
      
        
    }


    return self;
}

#pragma mark 创建界面
-(void)makeUI{

    //!取消、完成的view
    UIView * opreateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [opreateView setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    [self addSubview:opreateView];
    
    //!分割线
    UILabel * filterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [filterLabel setBackgroundColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [opreateView addSubview:filterLabel];
    
    //!取消
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancleBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    float btnWidth = opreateView.frame.size.height - filterLabel.frame.size.height;
    cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(filterLabel.frame), btnWidth, btnWidth);
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [opreateView addSubview:cancleBtn];
    
    //!完成
    UIButton * downBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [downBtn setTitle:@"完成" forState:UIControlStateNormal];
    downBtn.frame = CGRectMake(0, CGRectGetMaxY(filterLabel.frame), btnWidth, btnWidth);

    downBtn.frame = CGRectMake(opreateView.frame.size.width - btnWidth, CGRectGetMaxY(filterLabel.frame), btnWidth, btnWidth);
    [opreateView addSubview:downBtn];

    
    //!选择器
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(opreateView.frame), SCREEN_WIDTH, self.frame.size.height - opreateView.frame.size.height)];
    [self.pickerView setBackgroundColor:[UIColor colorWithHexValue:0xe2e2e2 alpha:1]];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    
}
//!列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;

}
//!行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return self.dataArray.count;

}
//!每行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return self.dataArray[row];

}
//!选中事件
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    //!得到选择的内容
    NSString * selectTitle = self.dataArray[row];
    
    //!在选择文字前面拼接空格，用于按UI要求显示
    NSString * showSelectTitle = [NSString stringWithFormat:@" %@",selectTitle];
    
    NSNumber * selectNum = nil;

    if (self.isShowReason) {//!是显示原因
        
        NSDictionary * getNumDic = @{@"质量问题":@"0",
                                     @"尺码问题":@"1",
                                     @"少件/破损":@"2",
                                     @"卖家发错货":@"3",
                                     @"未按约定时间发货":@"4",
                                     @"多拍/拍错/不想要":@"5",
                                     @"快递/物流问题":@"6",
                                     @"空包裹/少货":@"7",
                                     @"其他":@"8"};
        
        selectNum = [NSNumber numberWithInt:[getNumDic[selectTitle] intValue]];
       

    }else{//!是显示货物状态
    
        NSDictionary * getNumDic = @{@"未收到货":@"0",
                                     @"已收到货":@"1",
                                    };
        
        //!给服务器的数据：货物状态 0-未收到货 1-已收到货
        selectNum = [NSNumber numberWithInt:[getNumDic[selectTitle] intValue]];

        //        selectNum = [NSNumber numberWithInteger:(row - 1)];
    
    }
    
    //!如果选择的选项里面包含“请选择，返回的选择值为nil”
    if ([selectTitle containsString:@"请选择"]) {
        
        selectNum = nil;
    }
    
    if (self.selectBlock) {
        
        self.selectBlock(showSelectTitle,selectNum);
        
    }
    

}
#pragma mark 点击事件
//!取消
-(void)cancelBtnClick{

    if (self.sureAndCancelBlock) {
        
        self.sureAndCancelBlock();
        
    }
    
}
//!完成
-(void)downBtnClick{

    if (self.sureAndCancelBlock) {
        
        self.sureAndCancelBlock();
        
    }

}
//!刷新 showReason显示退款原因：yes  showReason 未收到货：yes
-(void)reloadDataIsShowReason:(BOOL)showReason withNoGetGoods:(BOOL)noGetGoods{

    
    self.isShowReason = showReason;
    
    if (showReason) {//!显示退款原因
    
        if (noGetGoods) {//!未收到货的情况
            
            //!仅退款：（1）待发货； （2）待收货,状态为 “未收到”
            self.dataArray = @[@"请选择退货原因",@"未按约定时间发货",@"多拍/拍错/不想要",@"少件/破损",@"快递/物流问题",@"空包裹/少货",@"其他"];
            
        }else{
        
            
            self.dataArray = @[@"请选择退货原因",@"质量问题",@"尺码问题",@"少件/破损",@"卖家发错货",@"其他"];
        
        }
    
        
    }else{//!显示货物状态
    
        self.dataArray = @[@"请选择货物状态",@"未收到货",@"已收到货"];

    }

    
    [self.pickerView reloadAllComponents];
    
    //!默认选择第一行
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    

    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
