//
//  WindowImgView.h
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 16/1/4.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"
@interface WindowImgView : UIView
@property (strong, nonatomic)  SMPageControl *pageControl;
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *imagesArr;

- (void)setImagesArr:(NSArray *)imagesArr;
@end
