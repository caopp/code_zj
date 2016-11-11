//
//  CSPAdressMagementTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"
@class CSPAddressMagementTableViewCell;
@protocol CSPAddressMagementCellDelegate <NSObject>

- (void)defaultButtonTaped:(UIButton *)sender;
- (void)editButtonTaped:(UIButton *)sender;
- (void)deleteButtonTaped:(UIButton *)sender cell:(CSPAddressMagementTableViewCell *)cell;

@end
@interface CSPAddressMagementTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

//收货人
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
//详细地址
@property (weak, nonatomic) IBOutlet UILabel *detaiAdressLabel;
//设为默认地址
@property (weak, nonatomic) IBOutlet UIButton *defuaultButton;
- (IBAction)defaultButtonClicked:(id)sender;
//设置默认
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
//编辑
@property (weak, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)editButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIImageView *deleteImageBtn;

- (IBAction)deleteButtonClicked:(id)sender;
//删除
@property (weak, nonatomic) IBOutlet UILabel *deleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;

@property (nonatomic,assign)id<CSPAddressMagementCellDelegate>delegate;

//根据参数获取cell的高度
-(void)getAddressMagementTableViewCellConsigneeDTO:(ConsigneeDTO *)consigneeDTO;

@end
