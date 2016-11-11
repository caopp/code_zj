//
//  CSPNormalSectionHeaderView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSPNormalSectionHeaderView;

@protocol CSPNormalSectionHeaderViewDelegate <NSObject>

@optional

- (void)sectionHeaderView:(CSPNormalSectionHeaderView*)sectionHeaderView reviewMerchantGoodsWithMerchantNo:(NSString*)merchantNo;

- (void)sectionHeaderView:(CSPNormalSectionHeaderView*)sectionHeaderView enquiryWithMerchantName:(NSString*)merchantName  andMerchantNo:(NSString*)merchantNo;

@end


@class OrderDetailDTO;

@interface CSPNormalSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign)id<CSPNormalSectionHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *merchantButton;

@property (weak, nonatomic) OrderDetailDTO* orderDetailInfo;

@end
