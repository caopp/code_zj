//
//  CSPShoppingCartBaseTypeTableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"

@class DoubleSku;
@class CartGoods;
@class CSPBaseCartTableViewCell;

@protocol CSPBaseCartTableViewCellDelegate <NSObject>

@optional

- (void)cartTableViewCell:(CSPBaseCartTableViewCell*)cartTableViewCell cartTableViewCellSkuValueChangedToValid:(BOOL)valid;
- (void)cartTableViewCell:(CSPBaseCartTableViewCell*)cartTableViewCell selectionStateChanged:(BOOL)selected;
- (void)cartTableViewCell:(CSPBaseCartTableViewCell *)cartTableViewCell deleteCartGoodsInfo:(CartGoods*)goodsInfo;

- (void)cartTableViewCellSelectionStateChanged;
- (void)cartTableViewCellSkuValueChanged;
- (void)cartTableViewCellSkuValueCannotSubtract;
- (void)cartTableViewCellSkuValueChangeFailed;

@end

extern const CGFloat kCustomTrailingSpace;

@interface CSPBaseCartTableViewCell : CSPBaseTableViewCell

@property (nonatomic, assign)id<CSPBaseCartTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton* selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sampleColorLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceDeleteButtonConstraint;

@property (nonatomic, strong)CartGoods* cartGoods;

- (void)setupWithCartGoodsInfo:(CartGoods*)cartGoodsInfo;
- (void)setDeleteEnable:(BOOL)enable;

- (void)updateCartBySkuDTO:(DoubleSku*)skuDTO valueType:(NSString*)valueType;
- (void)showLastLine:(BOOL)isHide;


@end
