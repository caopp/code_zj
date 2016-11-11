//
//  CPSMyOrderTopView.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSMyOrderTopView.h"

static NSInteger const tag = 101;

@implementation CPSMyOrderTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_COLOR(0x333333FF);
        self.isScroll = NO;
        return self;
    }
    return nil;
}

- (instancetype)initWithScrollView:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_COLOR(0x333333FF);
        self.btnScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.btnScrollView.delegate = self;
        self.btnScrollView.scrollsToTop = NO;
        
        [self.btnScrollView setContentSize:CGSizeMake(frame.size.width, frame.size.height)];
        [self.btnScrollView setShowsHorizontalScrollIndicator:NO];
        [self.btnScrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:self.btnScrollView];
        self.isScroll = YES;
        return self;
    }
    return nil;
}

- (CGFloat)getButtonWidth{
    
    return self.frame.size.width*1.0/self.titleArray.count;
}

- (void)initButton{
    
    if (!self.isScroll) {
        
        CGFloat width = [self getButtonWidth];
        
        CGFloat height = self.frame.size.height;
        
        for (int i = 0; i<self.titleArray.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(i*width, 0, width, height);
            
            [button setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setTitleColor:HEX_COLOR(0x999999FF) forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            
            button.tag = tag+i;
            
            [self addSubview:button];
        }
        
    }else {
        
        CGFloat width;
        if (self.titleArray.count == 4) {
         
            width = [self getButtonWidth];
            [self.btnScrollView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
            [self.btnScrollView setShowsHorizontalScrollIndicator:NO];
            [self.btnScrollView setShowsVerticalScrollIndicator:NO];
        }else {
            
            width = self.frame.size.width * 1.0 / 5;
            [self.btnScrollView setContentSize:CGSizeMake(width * 7, self.frame.size.height)];
            [self.btnScrollView setShowsHorizontalScrollIndicator:NO];
            [self.btnScrollView setShowsVerticalScrollIndicator:NO];
        }
        
        CGFloat height = self.frame.size.height;
        
        for (int i = 0; i < self.titleArray.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(i * width, 0, width, height);
            
            [button setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setTitleColor:HEX_COLOR(0x999999FF) forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            
            button.tag = tag+i;
            

            
            [self.btnScrollView addSubview:button];
        }
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

- (void)reloadTitleWithTitle:(NSString *)title integer:(NSInteger)integer{
    
    UIButton *button = [self.subviews objectAtIndex:integer];
    
    [button setTitle:title forState:UIControlStateNormal];
}

- (void)buttonClick:(UIButton *)sender{
    
    [self showButtonWithIndex:sender.tag-tag];
    
    self.chooseOrderTypeBlock(sender.tag-tag);
}

- (void)showButtonWithIndex:(NSInteger)index{
    
    if (self.isScroll) {
        
        for (UIButton *button in self.btnScrollView.subviews) {
            
            button.backgroundColor = [UIColor clearColor];
        }
        
        UIButton *button = (UIButton *)[self.btnScrollView viewWithTag:tag+index];
        if (button) {
            button.backgroundColor = [UIColor whiteColor];
        }
        
        if (index == 4) {
            
            [self.btnScrollView setContentOffset:CGPointMake(self.frame.size.width * 1.0 / 5 * 2, 0) animated:YES];
        }
    }else {
        
        for (UIButton *button in self.subviews) {
            
            button.backgroundColor = [UIColor clearColor];
        }
        
        UIButton *button = (UIButton *)[self viewWithTag:tag+index];
        if (button) {
            button.backgroundColor = [UIColor whiteColor];
        }
    }
}


- (void)removeAllSubviews{
    
    if (self.isScroll) {
        
        NSArray *scrollArray = self.btnScrollView.subviews;
        
        for (UIView *view in scrollArray) {
            
            [view removeFromSuperview];
        }
    }else {
        
        NSArray *array = self.subviews;
        
        for (UIView *view in array) {
            
            [view removeFromSuperview];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
