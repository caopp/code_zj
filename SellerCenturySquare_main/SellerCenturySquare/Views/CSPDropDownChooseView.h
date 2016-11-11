//
//  CSPDropDownChooseView.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

@interface CSPDropDownChooseView : CSPBaseCustomView

@property(nonatomic,strong)NSMutableArray *titleArray;

@property(nonatomic,copy)NSString *defaultTitle;

@property(nonatomic,strong)UIButton *mainButton;

@property (nonatomic,copy)void (^setFrameBlock)(BOOL isDropDown);

@end
