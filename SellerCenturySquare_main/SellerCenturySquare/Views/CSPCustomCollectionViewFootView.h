//
//  CSPCustomCollectionViewFootView.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

@interface CSPCustomCollectionViewFootView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *lineView;

//!分割线高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHight;


@end
