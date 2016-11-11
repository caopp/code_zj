//
//  RetailView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RetailViewLoad) {
    NormalRetailTableViewLoad            = 0,
    EditorRetailTableViewLoad            = 1,
};

@interface RetailView : UIView
@property (nonatomic,assign)RetailViewLoad retailLoad;

-(id)initWithFrame:(CGRect)frame nav:(UINavigationController *)nav;
@end
