//
//  GoodsCategorySecondMenuView.h
//  SellerCenturySquare
//
//  Created by 王剑粟 on 15/9/28.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^menuClick)(NSString * searchId);

@interface GoodsCategorySecondMenuView : UIView {
    
    float btnWidth;
    float btnHeight;
}

@property (strong, nonatomic) NSMutableArray * nameArray;

@property (strong, nonatomic) NSMutableArray * btnArray;

@property (strong, nonatomic) menuClick menuclick;

@property (strong, nonatomic) NSString * parentStructureNo;

@property (strong, nonatomic) NSString * selectStructureNo;

- (instancetype)initWithArray:(NSMutableArray *)array withParentView:(UIScrollView *)parentView withBlock:(menuClick)block;

@end
