//
//  CSPOrderSegmentView.m
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/10/8.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "CSPOrderSegmentView.h"
#define TITLE_WIDTH ([[UIScreen mainScreen] bounds].size.width/4)


@implementation CSPOrderSegmentView

//使用delegate设置
- (void)setDelegate:(id<OrderSegmentViewDelegate>)delegate {
    
    _delegate = delegate;
    
    //设置 6个标题
    titleArray = [NSArray arrayWithObjects:@"全部", @"待付款", @"待发货", @"待收货", @"交易完成", @"采购单取消", @"交易取消", nil];
    [self drawContent];
}


/**
 *  设置标题可以滑动
 */
- (void)drawContent {
 
    //创建一个滚动视图
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, self.frame.size.height)];
    
    
    //每个标题占用屏幕的1/4
    CGFloat contentWidth = Main_Screen_Width / 4;

    //水平滚动
    scrollView.showsHorizontalScrollIndicator = NO;
    //背景色
    scrollView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    //设置contentview的大小
    scrollView.contentSize = CGSizeMake(contentWidth * titleArray.count, self.frame.size.height);
    scrollView.bounces = NO;
    [self addSubview:scrollView];
    

    for (int i = 0; i < 7; i++) {
        //设置标题按钮
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * contentWidth, 0, contentWidth, self.frame.size.height)];
        [btn setBackgroundColor:[UIColor clearColor]];
        //按钮名字
        [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        //颜色
        [btn setTitleColor:[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1] forState:UIControlStateNormal];
        //字体大小
        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        btn.tag = 200 + i;
        [btn addTarget:self action:@selector(segmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
    }
    
    //
//    contentWidth = Main_Screen_Width / 3;
//    for (int i = 4; i < 7; i ++) {
//        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width + (i - 4) * contentWidth, 0, contentWidth, self.frame.size.height)];
//        [btn setBackgroundColor:[UIColor clearColor]];
//        [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
//        btn.tag = 200 + i;
//        [btn addTarget:self action:@selector(segmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [scrollView addSubview:btn];
//    }
}

/**
 *  按钮的点击操作
 *
 *  @param sender 对象
 */
- (void)segmentBtnClick:(id)sender {

    UIButton * btn = (UIButton *)sender;
    NSInteger index = btn.tag - 200;
    if (index != currentIndex) {
        
        [self selectSegmentAtIndex:index];
    }
}

- (void)selectSegmentAtIndex:(NSInteger)index {
    
    currentIndex = index;
    

    for (int i = 0; i < 7; i++) {
        //出来
        UIButton * btn = (UIButton *)[scrollView viewWithTag:200 + i];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1] forState:UIControlStateNormal];
    }
    
    UIButton * btn = (UIButton *)[scrollView viewWithTag:200 + index];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (self.delegate) {
        [self.delegate OrderSegmentViewClick:index];
    }
    
    [self moveScrollView];
}

//scrollView自动移动
- (void)moveScrollView {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width/4;
    
    
    if (currentIndex == 3) {
     
        [scrollView setContentOffset:CGPointMake(width *2, 0) animated:YES];
    }else if (currentIndex == 2 ) {
        
        [scrollView setContentOffset:CGPointMake(width, 0) animated:YES];
    }else if (currentIndex == 4) {
    
        [scrollView setContentOffset:CGPointMake(width * 3 , 0) animated:YES];
    }else if (currentIndex == 5) {
     
        [scrollView setContentOffset:CGPointMake(width * 3 , 0) animated:YES];
    }else if (currentIndex == 1)
    {
        [scrollView setContentOffset:CGPointMake(0 , 0) animated:YES];

    }
    
}


@end
