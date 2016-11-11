//
//  SetLevelNoticeTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCheckShopAuthorityNotification @"CheckShopAuthorityNotification"

@interface SetLevelNoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noticeL;
@property (nonatomic,assign) BOOL isBlackListNotice;

- (void)setNoticeInfo:(NSInteger)level;

@end
