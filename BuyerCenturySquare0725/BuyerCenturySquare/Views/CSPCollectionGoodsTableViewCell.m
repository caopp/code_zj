//
//  CSPCollectionGoodTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/17/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPCollectionGoodsTableViewCell.h"
#import "FavoriteDTO.h"
#import "UIImageView+WebCache.h"
#import "GoodsCollectionByTimeDTO.h"

typedef NS_ENUM(NSUInteger, CollectionInfoStyle) {
    CollectionInfoStyleByTime,
    CollectionInfoStyleByMerchant,
};

@interface CSPCollectionGoodsTableViewCell ()

@property (nonatomic, strong) CollectionGoods* collectionGoods;
@property (nonatomic, assign) CollectionInfoStyle style;

@end

@implementation CSPCollectionGoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.cancelCollectionButton.layer.cornerRadius = 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [UIView animateWithDuration:1 animations:^{
        self.leadingSpaceLayoutConstraint.constant  = editing ? 8 : -25;
    }];
}
- (IBAction)selectButtonClicked:(UIButton *)sender {
    self.collectionGoods.selected = !sender.selected;
    self.selectButton.selected = self.collectionGoods.selected;
}

- (void)setInvalid:(BOOL)invalid {
    _invalid = invalid;

    if (invalid) {
        [self.invalidImageView setHidden:NO];
    } else {
        [self.invalidImageView setHidden:YES];
    }
}

- (IBAction)cancelCollectionButtonClicked:(id)sender {
    
    [HttpManager sendHttpRequestForDelFavoriteWithGoodsNo:self.collectionGoods.goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:deleteFavourSuccess:)]) {
                [self.delegate tableViewCell:self deleteFavourSuccess:YES];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:deleteFavourSuccess:)]) {
                [self.delegate tableViewCell:self deleteFavourSuccess:NO];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:deleteFavourSuccess:)]) {
            [self.delegate tableViewCell:self deleteFavourSuccess:NO];
        }
    }];
}

- (void)setupWithMerchantOrderForCollectionInfo:(CollectionGoods*)collectionInfo {
    self.style = CollectionInfoStyleByMerchant;

    [self setupWithCollectionInfo:collectionInfo];
}

- (void)setupWithTimeOrderForCollectionInfo:(CollectionGoods*)collectionInfo {
    self.style = CollectionInfoStyleByTime;

    [self setupWithCollectionInfo:collectionInfo];
}

- (void)setupWithCollectionInfo:(CollectionGoods*)collectionInfo {
    self.selectButton.selected = collectionInfo.selected;
    self.collectionGoods = collectionInfo;
    self.titleLabel.text = self.collectionGoods.goodsName;
    [self.collectionButton setSelected:YES];
    self.cancelCollectionButton.hidden = YES;

    self.descriptionLabel.text = [NSString stringWithFormat:@"颜色: %@  起批: %ld", self.collectionGoods.color, self.collectionGoods.batchNumLimit];

    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.02f", self.collectionGoods.price] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:16]}];

    [priceString appendAttributedString:priceValueString];

    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.collectionGoods.pictureUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];

    self.priceLabel.attributedText = priceString;
}


- (IBAction)enquiryButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:startEnquiryWithGoodsInfo:)]) {
        [self.delegate tableViewCell:self startEnquiryWithGoodsInfo:self.collectionGoods];
    }
}

- (IBAction)merchantButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(merchantButtonClickedForCell:collectionInfo:)]) {
        [self.delegate merchantButtonClickedForCell:self collectionInfo:self.collectionGoods];
    }
}

- (IBAction)collectionButtonClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.cancelCollectionButton.hidden = sender.selected;

    

//    UIButton* collectionButton = sender;
//    BOOL state = !collectionButton.selected;
//
//    if (state) {
//        [HttpManager sendHttpRequestForAddGoodsFavoriteWithGoodsNo:self.collectionGoods.goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//                collectionButton.selected = state;
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
//    } else {
//        [HttpManager sendHttpRequestForDelFavoriteWithGoodsNo:self.collectionGoods.goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//                collectionButton.selected = state;
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
//    }
}
@end
