//
//  CSPCollectionGoodTableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/17/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"

@class CSPCollectionGoodsTableViewCell;
@class CollectionGoods;

@protocol CSPCollectionGoodsTableViewCellDelegate <NSObject>

@optional
- (void)tableViewCell:(CSPCollectionGoodsTableViewCell*)tableViewCell deleteFavourSuccess:(BOOL)isSucceed;
- (void)tableViewCell:(CSPCollectionGoodsTableViewCell *)tableViewCell startEnquiryWithGoodsInfo:(CollectionGoods*)goodsInfo;
- (void)merchantButtonClickedForCell:(CSPCollectionGoodsTableViewCell*)cell collectionInfo:(CollectionGoods*)collectionInfo;

@end

@interface CSPCollectionGoodsTableViewCell : CSPBaseTableViewCell

@property (nonatomic, assign)id<CSPCollectionGoodsTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *invalidImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign, getter=isInvalid) BOOL invalid;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingSpaceLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIButton *cancelCollectionButton;
- (IBAction)cancelCollectionButtonClicked:(id)sender;


- (void)setupWithMerchantOrderForCollectionInfo:(CollectionGoods*)collectionInfo;

- (void)setupWithTimeOrderForCollectionInfo:(CollectionGoods*)collectionInfo;

@end
