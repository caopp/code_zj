//
//  CSPRecommendViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GetShopGoodsListDTO.h"
@interface CSPRecommendViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)GetShopGoodsListDTO *getShopGoodsListDTO;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIScrollView *recommendScrollview;
@property (strong, nonatomic) IBOutletCollection(UICollectionView) NSArray *recommendArray;

@end
