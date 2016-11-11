//
//  AddMoreTagTableViewCell.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddMoreTagTableViewCell;
@protocol AddMoreTagTableViewDelegate <NSObject>

//点击删除按钮
- (void)deleteTheCurrentCell:(AddMoreTagTableViewCell *)cell;

//添加更多的标签
- (void)AddMoreTagSendDataStr:(NSString *)dataStr andCurrentCell:(AddMoreTagTableViewCell *)cell;

//键盘弹出的时候触发的方法
- (void)keyboardJumpCell:(AddMoreTagTableViewCell *)cell;
@end
@interface AddMoreTagTableViewCell : UITableViewCell

@property (nonatomic ,assign) id<AddMoreTagTableViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *deletedButton;
@property (weak, nonatomic) IBOutlet UITextField *tagNameTF;

@end
