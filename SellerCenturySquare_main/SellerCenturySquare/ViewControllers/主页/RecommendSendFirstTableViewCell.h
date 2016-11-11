//
//  RecommendSendFirstTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kModifyRecommendNumberNotification @"ModifyRecommendNumberNotification"

@interface RecommendSendFirstTableViewCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray *imagesArr;
@property (weak, nonatomic) IBOutlet UILabel *tipsL;


@end
