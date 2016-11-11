//
//  SlidePageManager.h
//  SlidePageTool
//
//  Created by 小胖的Mac on 16/6/16.
//  Copyright © 2016年 江文俊. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SlidePageSquareView.h"
#import "SlidePageLineView.h"

typedef NS_ENUM(NSInteger,SlidePageType){
    SlidePageTypeSquare,
    SlidePageTypeLine
};

@interface SlidePageManager : NSObject

/**
 *  根据数据创建选择器
 *
 *  @param dataArr   数据源  <NSString*>
 *  @param type      选择器类型
 *  @param bgColor 背景颜色 <UIColor*>
 *  @param squareViewColor 滑块的颜色 <UIColor*>
 *  @param unSelectTitleColor 未选中文字的颜色 <UIColor*>
 *  @param selectTitleColor 选中文字的颜色 <UIColor*>
 *  @param titleFont 文字的字体 <UIFont*>
 *  @return 选择器视图 UIScrollView
 */
- (UIScrollView *)createBydataArr:(NSArray<NSString *> *)dataArr slidePageType:(SlidePageType)type bgColor:(UIColor *)bgColor squareViewColor:(UIColor *)squareViewColor unSelectTitleColor:(UIColor*)unSelectTitleColor selectTitleColor:(UIColor *)selectTitleColor witTitleFont:(UIFont *)titleFont;



//- (UIScrollView *)createBydataArr:(NSArray<NSString *> *)dataArr slidePageType:(SlidePageType)type bgColor:(UIColor *)bgColor squareViewColor:(UIColor *)squareViewColor unSelectTitleColor:(UIColor*)unSelectTitleColor selectTitleColor:(UIColor *)selectTitleColor witTitleFont:(UIFont *)titleFont;


/**
 *  页面滚动时传入偏移量
 */
@property (nonatomic,assign) CGFloat  contentOffsetX;

/**
 *  页面结束滚动时传入偏移量
 */
@property (nonatomic,assign) CGFloat  endcontentOffsetX;


//!改变button的内容 (传入说第几个button，从0开始计算)

-(void)changeLabelValue:(NSInteger)btnIndex withTitle:(NSString *)btnTitleStr;


@end
