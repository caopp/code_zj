//
//  ChatTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"
#import "ECSession.h"
@interface ChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CustomBadge *chatBadge;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *detailInfoL;
@property (weak, nonatomic) IBOutlet UIImageView *AvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;



@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)ECSession *ecSession;


@end
