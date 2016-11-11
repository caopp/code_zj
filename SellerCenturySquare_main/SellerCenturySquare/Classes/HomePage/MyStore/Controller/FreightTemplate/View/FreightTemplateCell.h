//
//  FreightTemplateCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/2.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FreightTemplateCell;
@protocol FreightTemplateCellDelegate <NSObject>
//设置为默认地址
-(void)setDefaultBtn:(UIButton *)defaluBtn;

//查看设置好的运费模版
-(void)lookSettingPatientiaTemplateAction:(UIButton *)button;

//删除运费模版
-(void)deletePatientiaTemplateAction:(UIButton *)button templateCell:(FreightTemplateCell *)templateCell;

@end


@interface FreightTemplateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noDeletedLabel;

//设置代理
@property(weak,nonatomic)id<FreightTemplateCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *backgrondView;

//模版名称
@property (weak, nonatomic) IBOutlet UILabel *templateName;
//默认按钮
@property (weak, nonatomic) IBOutlet UIButton *patientiaButton;
//设置默认版本
@property (weak, nonatomic) IBOutlet UILabel *patientiaLabel;
//查看按钮
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
//分割线
@property (weak, nonatomic) IBOutlet UILabel *dividerLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deletedContrant;


//新添加按重量



//新添加按件数





@end
