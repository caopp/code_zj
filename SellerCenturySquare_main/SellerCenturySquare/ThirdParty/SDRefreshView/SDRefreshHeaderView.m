//
//  SDRefreshHeaderView.m
//  SDRefreshView
//
//  Created by aier on 15-2-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/**
 
 *******************************************************
 *                                                      *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题    *
 * 您可以发邮件到gsdios@126.com 或者 到                       *
 * https://github.com/gsdios?tab=repositories 提交问题     *
 *                                                      *
 *******************************************************
 
 */


#import "SDRefreshHeaderView.h"
#import "UIView+SDExtension.h"


@implementation SDRefreshHeaderView
{
    BOOL _hasLayoutedForManuallyRefreshing;
    

}

- (id)init {
    self = [super init];
    if (self) {
        _hasLayoutedForManuallyRefreshing = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textForNormalState = @"下拉可以加载最新数据";
        self.stateIndicatorViewNormalTransformAngle = 0;
        self.stateIndicatorViewWillRefreshStateTransformAngle = M_PI;
        [self setRefreshState:SDRefreshViewStateNormal];
        _hasLayoutedForManuallyRefreshing = YES;
                
    }
    return self;
}

- (CGFloat)yOfCenterPoint
{
    return - (self.sd_height * 0.5);
}
//当移动视图前调用
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.scrollViewEdgeInsets = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
}
/*
 layoutSubviews在以下情况下会被调用：
 
 1、init初始化不会触发layoutSubviews
 
 但是是用initWithFrame 进行初始化时，当rect的值不为CGRectZero时,也会触发
 
 2、addSubview会触发layoutSubviews
 
 3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
 
 4、滚动一个UIScrollView会触发layoutSubviews
 
 5、旋转Screen会触发父UIView上的layoutSubviews事件
 
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 
 */

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.center = CGPointMake(self.scrollView.sd_width * 0.5, [self yOfCenterPoint]);
    
    // 模拟手动刷新
    if (self.isManuallyRefreshing && !_hasLayoutedForManuallyRefreshing && self.scrollView.contentInset.top >= 0) {
        self.activityIndicatorView.hidden = NO;
        
        // 模拟下拉操作7
        CGPoint temp = self.scrollView.contentOffset;
        temp.y -= self.sd_height * 2;
        self.scrollView.contentOffset = temp; // 触发准备刷新
        temp.y += self.sd_height;
        self.scrollView.contentOffset = temp; // 触发刷新
        
        _hasLayoutedForManuallyRefreshing = YES;
        
    } else {
        
        self.activityIndicatorView.hidden = !self.isManuallyRefreshing;
   
    }
    
}
//启用模拟刷新
- (void)beginRefreshing
{
    self.isManuallyRefreshing = YES;
    _hasLayoutedForManuallyRefreshing = NO;
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    if (self.isManuallyRefreshing && !_hasLayoutedForManuallyRefreshing && self.scrollView.contentInset.top >= 0) {
        self.activityIndicatorView.hidden = NO;
        
        // 模拟下拉操作7
        CGPoint temp = self.scrollView.contentOffset;
        temp.y -= self.sd_height * 2;
        self.scrollView.contentOffset = temp; // 触发准备刷新
        temp.y += self.sd_height;
        self.scrollView.contentOffset = temp; // 触发刷新
        
        _hasLayoutedForManuallyRefreshing = YES;
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:SDRefreshViewObservingkeyPath] || self.refreshState == SDRefreshViewStateRefreshing) return;
    
    CGFloat y = [change[@"new"] CGPointValue].y;
    CGFloat criticalY = -self.sd_height - self.scrollView.contentInset.top;
    
    
    // 只有在 y<=0 以及 scrollview的高度不为0 时才判断
    if ((y > 0) || (self.scrollView.bounds.size.height == 0)) return;
    
    
    // 触发SDRefreshViewStateRefreshing状态
    if (y >= criticalY && (self.refreshState == SDRefreshViewStateWillRefresh) && !self.scrollView.isDragging) {
        

        [self setRefreshState:SDRefreshViewStateRefreshing];
        
    }
    
    // 触发SDRefreshViewStateWillRefresh状态
    if (y < criticalY && (SDRefreshViewStateNormal == self.refreshState)) {
        

        [self setRefreshState:SDRefreshViewStateWillRefresh];
    
    } else if (y >= criticalY && self.scrollView.isDragging && self.refreshState != SDRefreshViewStateNormal) {
        
        self.refreshState = SDRefreshViewStateNormal;
    }
    
    if (self.refreshState == SDRefreshViewStateNormal) {
        
        CGFloat scale = (-y - self.scrollView.contentInset.top) / self.sd_height;
        
        if ([self.delegate respondsToSelector:@selector(refreshView:didBecomeNormalStateWithMovingProgress:)]) {
            [self.delegate refreshView:self didBecomeNormalStateWithMovingProgress:scale];
        }
        
        if (self.normalStateOperationBlock) {
            self.normalStateOperationBlock(self, scale);
        }
      
    }
}

//创建顶部
-(void)makeHeaderView{
    
    if (_headerView==nil) {
        
        //屏幕宽 高度100  中间显示74
        
        float hight = 74;//!和 SDRefreshViewDefaultHeight 的值是一样的


        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, BOUNDSWIDTH, hight)];
    
        [_headerView setBackgroundColor:[UIColor clearColor]];

        [self addSubview:_headerView];
        
        
        //创建圆圈
        
        for (int i=0; i<4; i++) {
            
            UIImageView *circleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(X+i*(WIDTH+2), Y, WIDTH, WIDTH)];
            
            circleImageView.image=[UIImage imageNamed:@"circle"];
            [_headerView addSubview:circleImageView];
            
            switch (i) {
                case 0:
                    
                    _circleImageOne=circleImageView;
                    
                    break;
                case 1:
                    
                    _circleImageTwo=circleImageView;
                    
                    break;
                case 2:
                    
                    _circleImageThree=circleImageView;
                    
                    break;
                case 3:
                    
                    _circleImageFour=circleImageView;
                    
                    break;
                    
                default:
                    break;
            }
            
        }
        
        //创建顶部的竖条
        
        for (int i=0; i<2; i++) {
            
            UIImageView *lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake((X+WIDTH-5)+i*(WIDTH+2)-2, -145, 6, Y+150)];
            lineImageView.image=[UIImage imageNamed:@"downLine"];
            [_headerView addSubview:lineImageView];
            
            switch (i) {
                case 0:
                    
                    _lineImageOne=lineImageView;
                    
                    break;
                case 1:
                    
                    _lineImageTwo=lineImageView;
                    
                    break;
                    
                default:
                    break;
                    
            }
            
        }
        
        //底部的竖条
        UIImageView *lineImageThree=[[UIImageView alloc]initWithFrame:CGRectMake(X+WIDTH*3+2*3 + 1, Y+WIDTH-4, 6, hight - CGRectGetMaxY(_circleImageFour.frame)+ 4)];
        lineImageThree.image=[UIImage imageNamed:@"upLine"];
        [_headerView addSubview:lineImageThree];
        
        //交换tableView和headerView的位置
        [self.scrollView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    }
    
    
    
}
//创建动画
-(void)makeAni{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _circleImageOne.center=CGPointMake(60, Y+WIDTH/2);//去左边
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{//回到原来的位置+8 和第二个球碰撞
            
            _circleImageOne.frame=CGRectMake(X+8, Y, WIDTH, WIDTH);
            
        } completion:^(BOOL finished) {
            
            
            
            [UIView animateWithDuration:0.08 animations:^{
                
                //第一个球 和第二个球 变小
                _circleImageOne.transform=CGAffineTransformMakeScale(0.85, 1);
                _circleImageTwo.transform=CGAffineTransformMakeScale(0.8, 1);
                
                
            } completion:^(BOOL finished) {
                
                //第一个球和第二个球变回原来的大小
                [UIView animateWithDuration:0.1 animations:^{
                    
                    _circleImageOne.transform=CGAffineTransformMakeScale(1, 1);
                    _circleImageTwo.transform=CGAffineTransformMakeScale(1, 1);
                    
                    //第一个球变回原来的位置
                    _circleImageOne.frame=CGRectMake(X, Y, WIDTH, WIDTH);
                    
                    
                }];
                
                
            }];
            
            
            
            //第四个球被撞击出去
            [UIView animateWithDuration:0.3 animations:^{
                
                //第四个球被撞击出去
                _circleImageFour.center=CGPointMake(BOUNDSWIDTH-60, Y+WIDTH/2);
                
            } completion:^(BOOL finished) {
                
                //第四个球回原来的位置和第三个球碰撞
                [UIView animateWithDuration:0.2 animations:^{
                    
                    _circleImageFour.frame=CGRectMake(X+WIDTH*3+2*3-8, Y, WIDTH, WIDTH);
                    
                }completion:^(BOOL finished) {
                    
                    
                    //第三个球和第四个球变小  第四个球再变回原来的位置
                    [self thrreWithFourMove];
                    
                    
                }];
                
            }];
            
            
            
        }];
        
        
    }];
    
    
    
}
//第三个球和第四个球变小  第四个球再变回原来的位置
-(void)thrreWithFourMove{
    
    
    [UIView animateWithDuration:0.08 animations:^{
        
        //第三个球 和第四个球 变小
        _circleImageThree.transform=CGAffineTransformMakeScale(0.85, 1);
        _circleImageFour.transform=CGAffineTransformMakeScale(0.8, 1);
        
        
    } completion:^(BOOL finished) {
        
        //第三个球和第四个球变回原来的大小
        [UIView animateWithDuration:0.1 animations:^{
            
            _circleImageThree.transform=CGAffineTransformMakeScale(1, 1);
            _circleImageFour.transform=CGAffineTransformMakeScale(1, 1);
            
            
            _circleImageFour.frame=CGRectMake(X+3*WIDTH+3*2, Y, WIDTH, WIDTH);

            
        }completion:^(BOOL finished) {
            
            
            //第一四球变回原来的位置
//            [UIView animateWithDuration:0.2 animations:^{
//                
//                _circleImageFour.frame=CGRectMake(X+3*WIDTH+3*2, Y, WIDTH, WIDTH);
//                
//            }];
            
            
            
            
            
        }];
        
        
        [UIView animateWithDuration:0.4 animations:^{
            
            if (self.repeat) {//还需执行动画
                
                [self makeAni];
                
            }else{//不需要执行动画了
                
                
            }

        }];
        
        
        
    }];
    
}


@end
