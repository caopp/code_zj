//
//  RecommendHistoryTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendRecordDTO.h"

#define kCheckDetailInfoNotification @"CheckDetailInfoNotification"

@interface RecommendHistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recommendGoodsL;
@property (weak, nonatomic) IBOutlet UILabel *receivePersonL;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIButton *checkDetailButton;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIView *viewForImages;

@property (nonatomic,strong) NSMutableArray *imagesArr;
@property (nonatomic,strong) RecommendRecordDTO *recommendRecordDTO;

@end
