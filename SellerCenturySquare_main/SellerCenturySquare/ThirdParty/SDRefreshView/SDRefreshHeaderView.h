//
//  SDRefreshHeaderView.h
//  SDRefreshView
//
//  Created by aier on 15-2-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDRefreshView.h"
#define X ([UIScreen mainScreen].bounds.size.width-135)/2 //计算得到前面的距离
#define Y 21 //圆圈距离上面的距离
#define WIDTH 34 //圆圈的宽度

#define BOUNDSWIDTH  [UIScreen mainScreen].bounds.size.width  //屏幕的宽度

@interface SDRefreshHeaderView : SDRefreshView


//界面
//背景
@property (nonatomic, strong)  UIView *headerView;
//圆圈
@property (nonatomic, weak) UIImageView *circleImageOne;
@property (nonatomic, weak) UIImageView *circleImageTwo;
@property (nonatomic, weak) UIImageView *circleImageThree;
@property (nonatomic, weak) UIImageView *circleImageFour;
//竖条
@property (nonatomic, weak) UIImageView *lineImageOne;
@property (nonatomic, weak) UIImageView *lineImageTwo;
@property (nonatomic, weak) UIImageView *lineImageThree;


- (void)beginRefreshing;


@end
