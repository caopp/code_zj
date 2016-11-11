//
//  CSPOrderDetailSectionFooterView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailDTO;

@interface CSPOrderDetailSectionFooterView : UITableViewHeaderFooterView

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *deliveryLabelList;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *deliveryImageViewList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceLayoutConstraint;

@property (nonatomic, weak) OrderDetailDTO* orderDetailInfo;

+ (CGFloat)sectionHeightWithOrderDetail:(OrderDetailDTO*)orderDetailInfo;

@end
