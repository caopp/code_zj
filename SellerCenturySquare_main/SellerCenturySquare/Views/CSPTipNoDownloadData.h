//
//  CSPTipNoDownloadData.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

@interface CSPTipNoDownloadData : CSPBaseCustomView
/**
 *  当前等级
 */
@property (weak, nonatomic) IBOutlet UILabel *currentGradeLabel;
/**
 *  可下载商品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *downloadNumLabel;

@property (weak, nonatomic) IBOutlet UIView *tipEmptyDataView;

@property (weak, nonatomic) IBOutlet UIView *tipNoDownloadDataView;

@property (weak, nonatomic) IBOutlet UIView *tipNoDownloadingDataView;



@property (nonatomic,copy)void (^buyMoreImageBlock)();

- (IBAction)buyDownloadMoreImageButtonClick:(id)sender;

- (void)showView:(UIView *)view;



@end
