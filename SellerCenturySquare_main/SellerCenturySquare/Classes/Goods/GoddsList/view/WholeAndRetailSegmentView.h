//
//  WholeAndRetailSegmentView.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/20.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WholeAndRetailSegmentView : UIView

//!全部
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

//!批发
@property (weak, nonatomic) IBOutlet UIButton *wholesaleBtn;

//!批发/零售
@property (weak, nonatomic) IBOutlet UIButton *wholesaleAndRetailBtn;

//!零售
@property (weak, nonatomic) IBOutlet UIButton *retailBtn;


-(void)setSelectBtnType:(NSString *)selectType;


@property(nonatomic,copy)void (^changetypeBlock)(NSString *);


@end
