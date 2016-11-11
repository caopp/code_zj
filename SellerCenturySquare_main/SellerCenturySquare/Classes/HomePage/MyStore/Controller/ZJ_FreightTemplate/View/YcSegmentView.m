//
//  YcSegmentView.m
//  YCSegmentDemo
//
//  Created by hz_jiajia on 16/3/22.
//  Copyright © 2016年 hz_jiajia. All rights reserved.
//


#define ItemWidth   [UIScreen mainScreen].bounds.size.width/3

#define ItemHeight 40
#define HeaderBgCorlor [UIColor grayColor]  //顶部视图颜色

#define LabelNormalColor [UIColor grayColor] //未选中字体颜色
#define LabelSelectedColor [UIColor whiteColor]//选中字体颜色

#import "YcSegmentView.h"

//全部模板
#import "AllFreightTemplateView.h"
#import "WholesaleView.h"
#import "RetailView.h"


@implementation YcSegmentView
{
    UIView *_showContentLabelView;//用于展示当前label
    
    UIScrollView *_normalBgView;//正常状态下label的背景
    UIScrollView *_selectedBgView;//选中状态label的背景
    UIView *_btnBgView;//button层的背景
    
    UIScrollView *_scrollViewMain;//展示数据的scrollView
    
    NSInteger _countItem; //item总数
}

- (void)initializeData{
    _animation = YES;//过度动画
}

-(instancetype)initWithFrame:(CGRect)frame andHeaderHeight:(CGFloat )headerHeight andTitleArray:(NSArray *)titleArray andShowControllerNameArray:(NSArray *)showControllerArray nav:(UINavigationController *)nav;

{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setFrame:frame];
        [self initializeData];
        
        _countItem = [titleArray count];

        _normalBgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, headerHeight)];
        _normalBgView.delegate = self;
        [_normalBgView setBackgroundColor:HeaderBgCorlor];
        [self createLabelWith:LabelNormalColor andTitle:titleArray addToView:_normalBgView];
        [self addSubview:_normalBgView];
        
        _btnBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _normalBgView.contentSize.width, CGRectGetHeight(_normalBgView.frame))];
        [_btnBgView setBackgroundColor:[UIColor clearColor]];
        [_normalBgView addSubview:_btnBgView];

        
        for (int i = 0; i < [titleArray count]; i++) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i*ItemWidth, 0, ItemWidth, ItemHeight)];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:i];
            [_btnBgView addSubview:btn];
        }

        
        _showContentLabelView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ItemWidth, ItemHeight)];
        [_showContentLabelView setClipsToBounds:YES];
        [_normalBgView addSubview:_showContentLabelView];
        
        _selectedBgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, headerHeight)];
        
        [_selectedBgView setUserInteractionEnabled:NO];
        
        [_selectedBgView setBackgroundColor:HeaderBgCorlor];
        
        [_showContentLabelView addSubview:_selectedBgView];
        
        [self createLabelWith:LabelSelectedColor andTitle:titleArray addToView:_selectedBgView];
        
        _scrollViewMain = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_normalBgView.frame), SCREENW, SCREENH - CGRectGetMaxY(_normalBgView.frame))];
    
        [_scrollViewMain setBackgroundColor:[UIColor clearColor]];
        _scrollViewMain.contentSize = CGSizeMake(SCREENW * [titleArray count], CGRectGetHeight(_scrollViewMain.frame));
        _scrollViewMain.pagingEnabled = YES;
        _scrollViewMain.delegate = self;
        
        [_scrollViewMain setBounces:NO];
        
        [self addSubview:_scrollViewMain];
    
        
        //全部模板
        AllFreightTemplateView *allFreightTemplate = [[AllFreightTemplateView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, CGRectGetHeight(_scrollViewMain.frame)) nav:nav];
        [_scrollViewMain addSubview:allFreightTemplate];
        
    
        //批发端口模板
        WholesaleView *wholesaleView = [[WholesaleView alloc]initWithFrame:CGRectMake(SCREENW, 0, SCREENW, CGRectGetHeight(_scrollViewMain.frame)) nav:nav];
        [_scrollViewMain addSubview:wholesaleView];
        
     
        //零售端口模板
        RetailView *retailView = [[RetailView alloc]initWithFrame:CGRectMake(SCREENW * 2, 0, SCREENW , CGRectGetHeight(_scrollViewMain.frame)) nav:nav];
        [_scrollViewMain addSubview:retailView];
        

    }
    return self;
}

- (void)createLabelWith:(UIColor *)color andTitle:(NSArray *)titleArray addToView:(UIScrollView *)view{
    
    [view setShowsVerticalScrollIndicator:NO];
    [view setShowsHorizontalScrollIndicator:NO];
    
    [view setBounces:NO];
    //更改scrollView的大小
    [view setContentSize:CGSizeMake(ItemWidth * [titleArray count], CGRectGetHeight(view.frame))];

    //添加label
    for (int i = 0; i < [titleArray count]; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i*ItemWidth, 0, ItemWidth, ItemHeight)];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label setText:titleArray[i]];
        
        [label setBackgroundColor:color];
        [view addSubview:label];
    }
}


- (void)btnClick:(UIButton *)sender{
    
    [_scrollViewMain setContentOffset:CGPointMake(SCREENW * sender.tag, 0) animated:_animation];
    
    [self.delegate didSelectIndex:sender.tag];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView == _scrollViewMain){
        
        [_showContentLabelView setFrame:CGRectMake(scrollView.contentOffset.x*(ItemWidth/SCREENW), _showContentLabelView.frame.origin.y, _showContentLabelView.frame.size.width, _showContentLabelView.frame.size.height)];
        
        [_selectedBgView setContentOffset:CGPointMake(scrollView.contentOffset.x*(ItemWidth/SCREENW), 0)];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if(scrollView == _scrollViewMain){
        if (CGRectGetMaxX(_showContentLabelView.frame) - _normalBgView.contentOffset.x > SCREENW) {
            [_normalBgView setContentOffset:CGPointMake(_normalBgView.contentOffset.x + CGRectGetMaxX(_showContentLabelView.frame) - _normalBgView.contentOffset.x - SCREENW, 0) animated:YES];
        }else if (_normalBgView.contentOffset.x - CGRectGetMinX(_showContentLabelView.frame) > 0){
            [_normalBgView setContentOffset:CGPointMake(_normalBgView.contentOffset.x - _normalBgView.contentOffset.x + CGRectGetMinX(_showContentLabelView.frame), 0) animated:YES];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    NSInteger i = (targetContentOffset->x - 0)/SCREENW;
    
    NSString *str = [NSString stringWithFormat:@"%ld",i];
    
    NSNotification *notification = [[NSNotification alloc]initWithName:@"selectedBgViewNotification" object:self userInfo:@{@"name":str}];
    
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}


@end
