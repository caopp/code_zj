//
//  HasDownloadTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HasDownloadTableViewCell : UITableViewCell

//Size
@property (weak, nonatomic) IBOutlet UILabel *windowPicL;
@property (weak, nonatomic) IBOutlet UILabel *objectivePicL;

//Download
@property (weak, nonatomic) IBOutlet UIButton *windowDownloadAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *objectiveDownloadAgainButton;

//Clear
@property (weak, nonatomic) IBOutlet UIButton *windowClearButton;
@property (weak, nonatomic) IBOutlet UIButton *objectiveClearButton;

//Select
@property (weak, nonatomic) IBOutlet UIButton *windowSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *objectiveSelectButton;

//Hide
@property (weak, nonatomic) IBOutlet UIView *windowHideView;
@property (weak, nonatomic) IBOutlet UIView *objectiveHideView;


//编辑状态:YES  完成状态:NO
- (void)updateOnEditState:(BOOL)editState;
//隐藏窗口图
- (void)hideWindowPics:(BOOL)hide;
//隐藏客观图
- (void)hideObjectivePics:(BOOL)hide;
//选择按钮全选or全非选
- (void)allSelectedState:(BOOL)allSelected;

@end
