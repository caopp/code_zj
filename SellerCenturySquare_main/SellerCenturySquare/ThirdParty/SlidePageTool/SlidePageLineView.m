//
//  SlidePageLineView.m
//  SlidePageTool
//
//  Created by 小胖的Mac on 16/6/16.
//  Copyright © 2016年 江文俊. All rights reserved.
//

#import "SlidePageLineView.h"
@interface SlidePageLineView ()

@property (nonatomic,strong) NSArray<NSString*>        * dataArr;
@property (nonatomic,weak) UIView                      * lineView;
@property (nonatomic,strong) NSMutableArray <UILabel*> * labelMArr;
@end

@implementation SlidePageLineView

- (instancetype)initWithDataArr:(NSArray<NSString *> *)dataArr{
    if (dataArr.count==0) {
        return nil;
    }
    self = [super init];
    self.labelMArr = [NSMutableArray arrayWithCapacity:10];
    self.dataArr   = dataArr;
    [self setUpView];
    return self;
}
- (void)setUpView{
    self.pagingEnabled = YES;
    self.backgroundColor = [UIColor grayColor];
    self.showsHorizontalScrollIndicator = NO;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor blackColor];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    for (NSString* str in self.dataArr) {
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = str;
        [self addSubview:label];
        [self.labelMArr addObject:label];
    }
}
- (void)setUpLayout{
    CGFloat squareViewWidth = self.contentSize.width/self.dataArr.count;
    CGFloat squareViewHeight =  self.frame.size.height;
    CGFloat padding2 = 2;
    self.lineView.frame = CGRectMake(self.squareViewOriginX, squareViewHeight-padding2, squareViewWidth, padding2);
    for (int i=0; i<self.labelMArr.count; i++) {
        self.labelMArr[i].frame = CGRectMake(i*squareViewWidth, 0, squareViewWidth, squareViewHeight);
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



@end
