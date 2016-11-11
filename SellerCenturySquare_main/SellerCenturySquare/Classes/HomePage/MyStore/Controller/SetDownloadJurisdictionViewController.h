//
//  SetDownloadJurisdictionViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  !设置下载权限

#import "BaseViewController.h"

@interface SetDownloadJurisdictionViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *openOrCloseL;
@property (weak, nonatomic) IBOutlet UILabel *levelTipsL;
@property (weak, nonatomic) IBOutlet UIButton *button;

//等级权限
@property (nonatomic,assign) BOOL hasAuth;

//提示字符串显示或隐藏
- (void)setLevelTipsHidden:(BOOL)hide;

//开启或者关闭限制
- (void)openLimit:(BOOL)open;
@end
