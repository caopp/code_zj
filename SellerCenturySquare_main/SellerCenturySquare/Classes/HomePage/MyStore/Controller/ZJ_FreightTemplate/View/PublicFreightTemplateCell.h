//
//  PublicFreightTemplateCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublicFreightTemplateCellDelegate <NSObject>
//设置为默认地址
-(void)setDefaultBtn:(UIButton *)defaluBtn;

@end

@interface PublicFreightTemplateCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;


//选中按钮
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
//批发中模板名字
@property (weak, nonatomic) IBOutlet UILabel *selectFreightTemplateName;
//分割线
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
//选中后执行事件
- (IBAction)selectedButtonAction:(id)sender;
//代理设置
@property (weak,nonatomic)id<PublicFreightTemplateCellDelegate>delegate;

@end
