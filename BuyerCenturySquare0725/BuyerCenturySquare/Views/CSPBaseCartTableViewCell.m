//
//  CSPShoppingCartBaseTypeTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPBaseCartTableViewCell.h"
#import "CartListDTO.h"
#import "UIImageView+WebCache.h"

@implementation CSPBaseCartTableViewCell

const CGFloat kCustomTrailingSpace = 15.0f;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [self setDeleteEnable:editing];
    
    
}

- (void)setDeleteEnable:(BOOL)enable {
    
    self.trailingSpaceDeleteButtonConstraint.constant = enable ? kCustomTrailingSpace : -kCustomTrailingSpace * 5;
}

- (IBAction)selectButtonClicked:(id)sender {

    self.cartGoods.selected = !self.selectButton.selected;
    self.selectButton.selected = self.cartGoods.selected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(cartTableViewCell:selectionStateChanged:)]) {
        [self.delegate cartTableViewCell:self
                   selectionStateChanged:!self.selectButton.selected];
    }
}

- (IBAction)deleteButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cartTableViewCell:deleteCartGoodsInfo:)]) {
        [self.delegate cartTableViewCell:self deleteCartGoodsInfo:self.cartGoods];
    }
}

- (void)setupWithCartGoodsInfo:(CartGoods *)cartGoodsInfo {
    self.cartGoods = cartGoodsInfo;

//    if ([self.cartGoods.pictureUrl isEqualToString:@""]||self.cartGoods.pictureUrl == nil) {
//         self.titleImageView.image = [UIImage imageNamed:@"邮费专拍小图"];
//
//    }else{
        [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.cartGoods.pictureUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
//    }

    
    self.goodsNameLabel.text = self.cartGoods.goodsName;
    self.sampleColorLab.text = self.cartGoods.color;
    

    if (self.cartGoods.isValidCartGoods) {
        self.selectButton.selected = self.cartGoods.selected;
        [self.selectButton setHidden:NO];
    } else {
        [self.selectButton setHidden:YES];
    }
}

- (void)updateCartBySkuDTO:(DoubleSku*)skuDTO valueType:(NSString*)valueType {
    CartUpdateDTO *cartUpdateDTO = [[CartUpdateDTO alloc] init];

    cartUpdateDTO.goodsNo = self.cartGoods.goodsNo;
    cartUpdateDTO.cartType = self.cartGoods.cartType;
    cartUpdateDTO.skuNo = skuDTO.skuNo;
    cartUpdateDTO.skuName = skuDTO.skuName;
    cartUpdateDTO.totalQuantityOnGoods = [[NSNumber alloc] initWithInteger:self.cartGoods.cartQuantity];
    cartUpdateDTO.type = valueType;

    if ([valueType isEqualToString:@"spot"]) {
        cartUpdateDTO.NewQuantity = [NSNumber numberWithInteger:skuDTO.spotValue];
    } else {
        cartUpdateDTO.NewQuantity = [NSNumber numberWithInteger:skuDTO.futureValue];
    }

    [HttpManager sendHttpRequestForCartUpdateSuccess:cartUpdateDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            NSLog(@"============修改采购车数量成功==============");
        } else {
            NSLog(@"============修改采购车数量服务器报错==============");
            if (self.delegate && [self.delegate respondsToSelector:@selector(cartTableViewCellSkuValueChangeFailed)]) {
                [self.delegate cartTableViewCellSkuValueChangeFailed];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"============修改采购车数量网络异常==============");
    }];
}
- (void)showLastLine:(BOOL)isHide
{
    
}

@end
