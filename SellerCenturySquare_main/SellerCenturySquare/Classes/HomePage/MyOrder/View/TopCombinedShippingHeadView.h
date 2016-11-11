//
//  TopCombinedShippingHeadView.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderParentTableViewCell.h"

@interface TopCombinedShippingHeadView : MyOrderParentTableViewCell
//OrderListDTO

@property (nonatomic ,strong) OrderListDTO *recordListDto;
@property (nonatomic ,strong) MemberListDTO* recordMemberDto;

@end
