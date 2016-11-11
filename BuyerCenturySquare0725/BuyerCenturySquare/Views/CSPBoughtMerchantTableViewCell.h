//
//  CSPBoughtMerchantTableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/24/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MerchantListDetailsDTO;

@protocol CSPBoughtMerchantTableViewCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell*)tableViewCell startEnquiryWithMerchant:(MerchantListDetailsDTO*)merchantInfo;

@end

@interface CSPBoughtMerchantTableViewCell : UITableViewCell

@property (nonatomic, assign)id<CSPBoughtMerchantTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stallNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIView *topRightTipView;
@property (weak, nonatomic) IBOutlet UILabel *updatedGoodsAmountLabel;
@property (nonatomic, strong)MerchantListDetailsDTO* merchantInfo;

- (void)setupWithDictionary:(NSDictionary *)dictionary;

@end
