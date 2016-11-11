//
//  AllFreightTemplateCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AllFreightTemplateCell;

@protocol AllFreightTemplateCellDelegate <NSObject>
//模板进行查看
-(void)toViewFreightTemplateButton:(UIButton *)button;
//模板进行删除
-(void)deleteFreightTemplateButton:(UIButton *)button  templateCell:(AllFreightTemplateCell *)templateCell;
@end

@interface AllFreightTemplateCell : UITableViewCell
//模板名字
@property (weak, nonatomic) IBOutlet UILabel *freightTemplateName;
//查看按钮
@property (weak, nonatomic) IBOutlet UIButton *ToViewButton;
//查看按钮行为
- (IBAction)didClickToViewButtonAction:(id)sender;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
//删除按钮行为
- (IBAction)didClickDeleteButtonAction:(id)sender;
//分割线
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
//代理
@property (weak,nonatomic) id<AllFreightTemplateCellDelegate>delegate;
//包邮
@property (weak, nonatomic) IBOutlet UILabel *PackageMailLabel;

@end
