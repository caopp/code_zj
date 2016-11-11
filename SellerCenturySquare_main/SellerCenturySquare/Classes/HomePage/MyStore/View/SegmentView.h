//
//  SegmentView.h
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 16/1/7.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SegmentViewDelegate<NSObject>
@end;
@interface SegmentView : UIView
@property(nonatomic,strong) UIButton *objectBtn;
@property(nonatomic,strong) UIButton *reftBtn;
@property(nonatomic,strong) UIButton *attrBtn;
@property (nonatomic ,assign)id<SegmentViewDelegate>delegate;
@end
