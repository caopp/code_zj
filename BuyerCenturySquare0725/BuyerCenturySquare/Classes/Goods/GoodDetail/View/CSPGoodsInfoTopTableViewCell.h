//
//  CSPGoodsInfoTopTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/7/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"
#import "SMPageControl.h"
@interface CSPGoodsInfoTopTableViewCell : CSPBaseTableViewCell<UIScrollViewDelegate>
//@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet SMPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *imagesArr;

- (void)setImagesArr:(NSArray *)imagesArr;
@end
