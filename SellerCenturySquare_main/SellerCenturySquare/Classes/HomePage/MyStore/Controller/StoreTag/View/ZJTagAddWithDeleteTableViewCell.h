//
//  ZJTagAddWithDeleteTableViewCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJTagAddWithDeleteTableViewCellDelegate <NSObject>

-(void)deleteTagBtnActionBtnTag:(NSIndexPath *)BtnTag;


-(void)textField:(NSIndexPath *)textField;

@end

@interface ZJTagAddWithDeleteTableViewCell : UITableViewCell<UITextFieldDelegate>
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
//输入内容
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;

@property(weak,nonatomic)NSIndexPath *index_row;
//代理方法
@property (weak,nonatomic)id<ZJTagAddWithDeleteTableViewCellDelegate>delegate;

@end
