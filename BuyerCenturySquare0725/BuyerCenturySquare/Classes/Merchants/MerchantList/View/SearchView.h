//
//  SearchView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

//!界面被点击的时候调用的方法
@property(nonatomic,copy) void(^searchViewTapBlock)();



@end
