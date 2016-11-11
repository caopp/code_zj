//
//  FreightTempView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DefineTextField;
@protocol FreightTempViewDelegate <NSObject>

-(void)selectedEventAction:(UIButton *)selectedButton   section:(NSInteger)section;

-(void)selectedButtonTitle:(NSString *)title section:(NSInteger)section  buttonAction:(UIButton *)selectedButton;

//进行数据筛选
//添加按重量进行筛选执行事件
-(void)executedByWeight:(UIButton *)byWeightButton;

//添加按件数进行筛选执行事件
-(void)executedByCount:(UIButton *)byCounttButton;




@end

@interface FreightTempView : UIView<UITextFieldDelegate>

//选中显示tableView

@property (weak, nonatomic) IBOutlet UILabel *detailAresLabel;

@property (weak, nonatomic) IBOutlet UITableView *selectedTableView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIView *view;


@property (nonatomic,assign)NSInteger section;

@property (weak,nonatomic)id<FreightTempViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *selectedTypeButton;


//设置模版名字

@property (weak, nonatomic) IBOutlet UITextField *templateName;
//第一个label
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;


@property (weak, nonatomic) IBOutlet UILabel *firstMoneyLabel;

@property (weak, nonatomic) IBOutlet UITextField *firstMoneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;




@property (weak, nonatomic) IBOutlet UILabel *goOnLabel;

@property (weak, nonatomic) IBOutlet UILabel *goOnUnitLabel;
@property (weak, nonatomic) IBOutlet UITextField *goOnMoneyTextField;




@property (weak, nonatomic) IBOutlet UILabel *goOnweightLabel;

@property (weak, nonatomic) IBOutlet UITextField *goOnWeightTextField;


- (IBAction)didClickSelectedEventAction:(UIButton *)sender;


//设置新添加按重量

@property (weak, nonatomic) IBOutlet UIButton *weightButton;


- (IBAction)didClickWeightButtonAction:(UIButton *)sender;

//设置新添加按件数

@property (weak, nonatomic) IBOutlet UIButton *countButton;

- (IBAction)didClickCountButtonAction:(UIButton *)sender;






@end
