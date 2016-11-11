//
//  CPSMainViewController.h
//  SellerCenturySquare
//
//  Created by clz on 15/7/28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomBadge.h"







@interface CPSMainViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

// !顶部的view
@property (weak, nonatomic) IBOutlet UIView *headerView;
// !待发货提醒的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliverBageWith;



//Badge
@property (weak, nonatomic) IBOutlet CustomBadge *myShopBadge;
@property (weak, nonatomic) IBOutlet CustomBadge *waitingForDeliveryBadge;

@property (weak, nonatomic) IBOutlet CustomBadge *inviteBadge;

//!站内信的提示红点
@property (weak, nonatomic) IBOutlet CustomBadge *noticeCenter;
//
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *waitDispatchGoodsButton;

@property (weak, nonatomic) IBOutlet UILabel *shopNameL;
@property (weak, nonatomic) IBOutlet UIButton *shopNameBtn;


@property (weak, nonatomic) IBOutlet UIButton *levelButton;


@property (weak, nonatomic) IBOutlet UIButton *myShopBtn;

// !当前界面是否显示
@property(nonatomic,assign)BOOL isShowSelf;



- (IBAction)didClickSettingAction:(id)sender;

@end
