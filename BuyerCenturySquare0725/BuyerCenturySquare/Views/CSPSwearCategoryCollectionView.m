//
//  CSPSwearCategoryCollectionView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/7/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPSwearCategoryCollectionView.h"

#define SCREEN_WIDTH MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

const CGFloat leftMargin = 8.0f;
const CGFloat rightMargin = 8.0f;

@implementation CSPSwearCategoryCollectionView

+ (CSPSwearCategoryCollectionView*)swearCategoryCollectionViewWithCategory:(NSArray*)category {

    CGFloat width = (SCREEN_WIDTH - leftMargin - rightMargin) / 5;

    CSPSwearCategoryCollectionView* collectionView = [[CSPSwearCategoryCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ceil(category.count / 5) * width)];

    return collectionView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        layout.sectionInset = UIEdgeInsetsMake(0, leftMargin, 0, rightMargin);
        self.collectionViewLayout = layout;
    }

    return self;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (SCREEN_WIDTH - leftMargin - rightMargin) / 5;

    return CGSizeMake(width, width);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
