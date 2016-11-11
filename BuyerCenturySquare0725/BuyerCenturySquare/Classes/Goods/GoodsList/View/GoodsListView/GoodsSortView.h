//
//  GoodsSortView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/9/12.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsSortDTO.h"

@interface GoodsSortView : UIView

//!推荐
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;

//!按时间
@property (weak, nonatomic) IBOutlet UIButton *byTimeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *byTimeImgaeView;

//!按销量
@property (weak, nonatomic) IBOutlet UIButton *bySalesBtn;

@property (weak, nonatomic) IBOutlet UIImageView *bySalesImageView;


//!按价格
@property (weak, nonatomic) IBOutlet UIButton *byPriceBtn;

@property (weak, nonatomic) IBOutlet UIImageView *byPriceImageView;

//!筛选
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;

@property(nonatomic,strong) GoodsSortDTO * sortDTO;

@property(nonatomic,copy) void(^sortClickBlock)();


//!初始化
-(void)setGoodsSortDTO:(GoodsSortDTO *)sortDTO;





@end

