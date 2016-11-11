//
//  CSPSwearCategoryCollectionViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/7/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPSwearCategoryCollectionViewCell.h"

@implementation CSPSwearCategoryCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.borderColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1].CGColor;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        NSString* imageName = [NSString stringWithFormat:@"04_商品列表_%@选中状态", self.categoryNameLabel.text];

        self.backgroundColor = [UIColor blackColor];
        self.categoryImageView.image = [UIImage imageNamed:imageName];
        self.categoryNameLabel.textColor = [UIColor whiteColor];
    } else {
        NSString* imageName = [NSString stringWithFormat:@"04_商品列表_%@未选中状态", self.categoryNameLabel.text];

        self.backgroundColor = [UIColor whiteColor];
        self.categoryImageView.image = [UIImage imageNamed:imageName];
        self.categoryNameLabel.textColor = [UIColor blackColor];
    }
}

@end
