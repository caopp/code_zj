//
//  EditorTableViewCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditorTableViewCellDelegate <NSObject>

-(void)setEditorButton:(UIButton *)editorButton;

@end

@interface EditorTableViewCell : UITableViewCell

//编辑模板名字
@property (weak, nonatomic) IBOutlet UILabel *editorNameLabel;
//设置模板label
@property (weak, nonatomic) IBOutlet UILabel *setFreightTemplateLabel;
//选中模板按钮
@property (weak, nonatomic) IBOutlet UIButton *setFreightTemplateButton;
//分割线
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
//选中模板按钮事件
- (IBAction)didClickSelectdFreightButtonAction:(id)sender;


@property (weak,nonatomic)id<EditorTableViewCellDelegate>delegate;
@end




