//
//  SlidePageManager.m
//  SlidePageTool
//
//  Created by 小胖的Mac on 16/6/16.
//  Copyright © 2016年 江文俊. All rights reserved.
//

#import "SlidePageManager.h"
@interface SlidePageManager (){

    UIColor * _bgColor;
    UIColor * _squareViewColor;
    UIColor * _unSelectTitleColor;
    UIColor * _selectTitleColor;
    UIFont * _titleFont;

}
@property (nonatomic,strong) NSArray <NSString*>       * dataArr;
@property (nonatomic,assign) SlidePageType               slidePageType;
@property (nonatomic,strong) SlidePageSquareView       * slidePageSquareView;
@property (nonatomic,strong) SlidePageLineView         * slidePageLineView;

@end

@implementation SlidePageManager

- (UIScrollView *)createBydataArr:(NSArray<NSString *> *)dataArr slidePageType:(SlidePageType)type bgColor:(UIColor *)bgColor squareViewColor:(UIColor *)squareViewColor unSelectTitleColor:(UIColor*)unSelectTitleColor selectTitleColor:(UIColor *)selectTitleColor witTitleFont:(UIFont *)titleFont{
    
    _bgColor = bgColor;
    _squareViewColor = squareViewColor;
    _unSelectTitleColor = unSelectTitleColor;
    _selectTitleColor = selectTitleColor;
    _titleFont = titleFont;
    
    self.dataArr       = dataArr;
    self.slidePageType = type;
    return  [self setUpView];
    
}

- (UIScrollView*)setUpView{
    switch (self.slidePageType) {
        case SlidePageTypeSquare:{
          self.slidePageSquareView  = [[SlidePageSquareView alloc]initWithDataArr:self.dataArr bgColor:_bgColor squareViewColor:_squareViewColor unSelectTitleColor:_unSelectTitleColor selectTitleColor:_selectTitleColor withTitleFont:_titleFont];
            self.slidePageSquareView.scrollsToTop = NO;
            return self.slidePageSquareView;
        }
            break;
        case SlidePageTypeLine:{
            self.slidePageLineView  = [[SlidePageLineView alloc]initWithDataArr:self.dataArr];
            self.slidePageLineView.scrollsToTop = NO;
            return self.slidePageLineView;
        }
            break;
    }
}

- (void)setContentOffsetX:(CGFloat)contentOffsetX{
    _contentOffsetX = contentOffsetX;

    switch (self.slidePageType) {
        case SlidePageTypeSquare:{
            CGFloat scale = self.slidePageSquareView.contentSize.width/[UIScreen mainScreen].bounds.size.width;
            CGFloat moveDistance = contentOffsetX * (scale/self.dataArr.count);
            self.slidePageSquareView.squareViewOriginX = moveDistance;
        }
            break;
        case SlidePageTypeLine:{
            CGFloat scale = self.slidePageLineView.contentSize.width/[UIScreen mainScreen].bounds.size.width;
            CGFloat moveDistance = contentOffsetX * (scale/self.dataArr.count);
            self.slidePageLineView.squareViewOriginX = moveDistance;
        }
            break;
    }

}
- (void)setEndcontentOffsetX:(CGFloat)endcontentOffsetX{
    _endcontentOffsetX = endcontentOffsetX;
    switch (self.slidePageType) {
        case SlidePageTypeSquare:{
            self.slidePageSquareView.endcontentOffsetX = endcontentOffsetX;
        }
            break;
        case SlidePageTypeLine:{
            self.slidePageLineView.endcontentOffsetX = endcontentOffsetX;
        }
            break;
    }

}

//改变button的内容
-(void)changeLabelValue:(NSInteger)btnIndex withTitle:(NSString *)btnTitleStr{
    
    [self.slidePageSquareView changeBtnValue:btnIndex withTitle:btnTitleStr];

}

@end
