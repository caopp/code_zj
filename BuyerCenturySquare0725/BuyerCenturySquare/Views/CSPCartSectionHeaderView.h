//
//  CSPCartSectionHeaderView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/1/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CartSectionHeaderViewStyle) {
    CartSectionHeaderViewStyleNormal,
    CartSectionHeaderViewStyleWarning,
};

@class CartMerchant;

@class SaleMerchantCondition;

@class CSPCartSectionHeaderView;

@protocol CSPCartSectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderView:(CSPCartSectionHeaderView *)sectionHeaderView selectionStatusChanged:(BOOL)isSelected;

- (void)sectionHeaderView:(CSPCartSectionHeaderView *)sectionHeaderView showMerchantGoods:(NSString*)merchantNo;

- (void)sectionHeaderView:(CSPCartSectionHeaderView *)sectionHeaderView startEnquiryWithMerchantInfo:(CartMerchant *)merchantInfo;

- (void)sectionHeaderView:(CSPCartSectionHeaderView *)sectionHeaderView reloadSection:(NSInteger)section;

@end



@interface CSPCartSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign)id<CSPCartSectionHeaderViewDelegate> delegate;

@property (nonatomic, assign)CartSectionHeaderViewStyle style;

@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *boughtCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *merchantNameButton;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchanName;

@property (weak, nonatomic) IBOutlet UIImageView *showDoMeetImage;

@property (nonatomic, assign)NSInteger section;
@property (nonatomic, weak)CartMerchant* merchantInfo;

- (void)setupWithMerchantInfo:(CartMerchant*)merchantInfo section:(NSInteger)section;

- (void)updateWarningByMerchantCondition:(SaleMerchantCondition*)merchantCondition;

@end


