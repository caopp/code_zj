//
//  CSPConsigneeSectionHeaderView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConsigneeDTO;
@class OrderDetailDTO;
@class CSPConsigneeSectionHeaderView;

@protocol CSPConsigneeSectionHeaderViewDelegate <NSObject>

- (void)changeConsigneeButtonClicked;

@end

@interface CSPConsigneeSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign)id<CSPConsigneeSectionHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIButton *indicationButton;

//添加收货地址
@property (weak, nonatomic) IBOutlet UIView *addShippingAddressView;

@property (weak, nonatomic) ConsigneeDTO* consignee;
@property (weak, nonatomic) OrderDetailDTO* orderDetailInfo;

+ (CGFloat)sectionHeaderHeightWithContent:(NSString*)content;

@end
