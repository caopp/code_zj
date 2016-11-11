//
//  ContactsTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendReceiverDTO.h"

#define kContactsSelectChangedNotification @"ContactsSelectChangedNotification"

@interface ContactsTableViewCell : UITableViewCell
//邀请
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,copy) NSString *phoneNum;


@property (weak, nonatomic) IBOutlet UILabel *nameL;

//推荐
@property (nonatomic,strong) NSMutableDictionary *recommendSelectedInfo;
@property (nonatomic,strong) RecommendReceiverDTO *recommendReceiverDTO;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

- (void)setButtonSelected:(BOOL)selected;

@end
