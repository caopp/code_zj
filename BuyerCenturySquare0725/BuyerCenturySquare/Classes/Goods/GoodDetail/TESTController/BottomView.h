//
//  BottomView.h
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 16/1/7.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BottomViewDelegate<NSObject>
@end
@interface BottomView : UIView
@property(nonatomic, strong) UIButton *btnShop;
@property(nonatomic, strong) UIButton *button;
@property(nonatomic, strong) UILabel  *startNumL;
@property(nonatomic, strong) UILabel  *hasSelectedNumL;
@property(nonatomic, strong) UIView   *lineView;
@property(nonatomic, strong) UIView *shopPoint;
@property(nonatomic, assign) id<BottomViewDelegate>delegate;
@end
