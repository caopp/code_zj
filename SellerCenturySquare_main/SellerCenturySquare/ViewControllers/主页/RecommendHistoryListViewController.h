//
//  RecommendHistoryListViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "GetRecommendRecordListDTO.h"

@interface RecommendHistoryListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) GetRecommendRecordListDTO *getRecommendRecordListDTO;

@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *delBarButton;


@end
