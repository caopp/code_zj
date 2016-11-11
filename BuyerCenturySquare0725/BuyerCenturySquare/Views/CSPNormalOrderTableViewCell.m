//
//  CSPConfirmOrderTypeATableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPNormalOrderTableViewCell.h"
#import "CartListConfirmDTO.h"
#import "OrderGroupListDTO.h"
#import "OrderDetailDTO.h"

@implementation CSPNormalOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.sizeLabels enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *stop) {
        label.adjustsFontSizeToFitWidth = YES;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCartGoodsInfo:(CartConfirmGoods *)cartGoodsInfo {
    [super setCartGoodsInfo:cartGoodsInfo];

    [self.sizeLabels enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *stop) {
        if (idx < self.cartGoodsInfo.sizes.count) {
            [label setHidden:NO];
            NSMutableString* sizeContent = [NSMutableString stringWithString:self.cartGoodsInfo.sizes[idx]];
            [sizeContent replaceCharactersInRange:[sizeContent rangeOfString:@":"] withString:@" x "];
            label.text = sizeContent;
            
        } else {
            [label setHidden:YES];
        }
    }];
    

    self.colorLabel.text = [NSString stringWithFormat:@"颜色: %@", self.cartGoodsInfo.color];
}

- (void)setOrderGoodsInfo:(OrderGoods *)orderGoodsInfo {
    [super setOrderGoodsInfo:orderGoodsInfo];

    [self.sizeLabels enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *stop) {
        if (idx < self.orderGoodsInfo.sizes.count) {
            [label setHidden:NO];
            NSMutableString* sizeContent = [NSMutableString stringWithString:self.orderGoodsInfo.sizes[idx]];
            if (sizeContent.length > 0) {
                [sizeContent replaceCharactersInRange:[sizeContent rangeOfString:@":"] withString:@" x "];
                label.text = sizeContent;
            } else {
                label.text = @"";
                NSLog(@"%@", self.orderGoodsInfo.sizes[idx]);
            }
            
        } else {
            [label setHidden:YES];
        }
    }];

    self.colorLabel.text = [NSString stringWithFormat:@"颜色: %@", self.orderGoodsInfo.color];
}

- (void)setOrderGoodsItemInfo:(OrderGoodsItem *)orderGoodsItemInfo {
    [super setOrderGoodsItemInfo:orderGoodsItemInfo];

    [self.sizeLabels enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *stop) {
        if (idx < self.orderGoodsItemInfo.sizes.count) {
            [label setHidden:NO];
            NSMutableString* sizeContent = [NSMutableString stringWithString:self.orderGoodsItemInfo.sizes[idx]];
            [sizeContent replaceCharactersInRange:[sizeContent rangeOfString:@":"] withString:@" x "];
            label.text = sizeContent;
        } else {
            [label setHidden:YES];
        }
    }];

    self.colorLabel.text = [NSString stringWithFormat:@"颜色: %@", self.orderGoodsItemInfo.color];
}


@end
