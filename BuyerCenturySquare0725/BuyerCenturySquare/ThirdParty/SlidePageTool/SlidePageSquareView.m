//
//  SlidePageSquareView.m
//  SlidePageTool
//
//  Created by 小胖的Mac on 16/6/16.
//  Copyright © 2016年 江文俊. All rights reserved.
//

#import "SlidePageSquareView.h"

@interface SlidePageSquareView ()
{

    UIColor * _bgColor;
    UIColor * _squareViewColor;
    UIColor * _unSelectTitleColor;
    UIColor * _selectTitleColor;
    UIFont * _titleFont;


}
@property (nonatomic,strong) NSArray<NSString*>        * dataArr;
@property (nonatomic,weak) UIView                      * squareView;
@property (nonatomic,weak) UIView                      * bgView;
@property (nonatomic,strong) NSMutableArray <UIButton*> * bottomBtnMArr;
@property (nonatomic,strong) NSMutableArray <UIButton*> * topBtnMArr;


@property (nonatomic ,strong)UIView *lineView;

@end

@implementation SlidePageSquareView

- (instancetype)initWithDataArr:(NSArray<NSString *> *)dataArr bgColor:(UIColor *)bgColor squareViewColor:(UIColor *)squareViewColor unSelectTitleColor:(UIColor*)unSelectTitleColor selectTitleColor:(UIColor *)selectTitleColor withTitleFont:(UIFont *)titleFont{
    if (dataArr.count==0) {
        return nil;
    }
    self = [super init];
    
    _bgColor = bgColor;
    _squareViewColor = squareViewColor;
    _unSelectTitleColor = unSelectTitleColor;
    _selectTitleColor = selectTitleColor;
    _titleFont = titleFont;

    
    self.bottomBtnMArr = [NSMutableArray arrayWithCapacity:10];
    self.topBtnMArr    = [NSMutableArray arrayWithCapacity:10];
    self.dataArr       = dataArr;
    [self setUpView];
    return self;
    
    
}
- (void)setUpView{
    self.backgroundColor = _bgColor;
    self.showsHorizontalScrollIndicator = NO;
    
    for (int i=0; i<self.dataArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.dataArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:_unSelectTitleColor forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (_titleFont) {
            
            [btn.titleLabel setFont:_titleFont];
        }
        [self.bottomBtnMArr addObject:btn];
    }
    
    UIView *squareView = [[UIView alloc]init];
    squareView.backgroundColor = _squareViewColor ;
    squareView.layer.masksToBounds = YES;
    [self addSubview:squareView];
    self.squareView = squareView;
    
//    UIView *lineView = [[UIView alloc] init];
//    self.lineView = lineView;
////    lineView.backgroundColor = [UIColor redColor];
    
    self.layer.masksToBounds = YES;
//    [self addSubview:lineView];
    
    
    
    
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor clearColor];
    [self.squareView addSubview:bgView];
    self.bgView = bgView;
    
    for (int i=0; i<self.dataArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.dataArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:_selectTitleColor forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (_titleFont) {
            
            [btn.titleLabel setFont:_titleFont];
        }
        [self.bgView addSubview:btn];
        [self.topBtnMArr addObject:btn];
    }
   
    
}
- (void)setUpLayout{
    CGFloat squareViewWidth = self.contentSize.width/self.dataArr.count;
    CGFloat squareViewHeight =  self.frame.size.height;
    self.lineView.frame = CGRectMake(self.squareViewOriginX, squareViewHeight-1, squareViewWidth, 1);
    
    self.squareView.frame = CGRectMake( self.squareViewOriginX, 0, squareViewWidth, squareViewHeight);
    self.bgView.frame     = CGRectMake(-self.squareViewOriginX, 0, squareViewWidth, squareViewHeight);
    for (int i=0; i<self.bottomBtnMArr.count; i++) {
        self.bottomBtnMArr[i].frame = CGRectMake(i*squareViewWidth, 0, squareViewWidth, squareViewHeight);
    }
    for (int i=0; i<self.topBtnMArr.count; i++) {
        self.topBtnMArr[i].frame    = CGRectMake(i*squareViewWidth, 0, squareViewWidth, squareViewHeight);
    }
}

- (void)slidePageSquareViewSlide{
    CGFloat squareViewWidth = self.contentSize.width/self.dataArr.count;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat offsetX = self.squareViewOriginX - screenWidth / 2 + squareViewWidth / 2;
    if (offsetX + screenWidth > self.contentSize.width){
        offsetX = self.contentSize.width - screenWidth;
    }
    
    if (offsetX < 0){
        offsetX = 0;
    }
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setUpLayout];
  
}

- (void)setSquareViewOriginX:(CGFloat)squareViewOriginX{
    _squareViewOriginX = squareViewOriginX;
    [self setUpLayout];
}
- (void)setEndcontentOffsetX:(CGFloat)endcontentOffsetX{
    _endcontentOffsetX = endcontentOffsetX;
    [self slidePageSquareViewSlide];
}
- (void)btnClick:(UIButton*)btn{
    if ([self.delegateForSlidePage respondsToSelector:@selector(slidePageSquareView:andBtnClickIndex:)]) {
        [self.delegateForSlidePage slidePageSquareView:self andBtnClickIndex:(btn.tag-100)];
    }
}


@end
