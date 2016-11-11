//
//  CSPBackgroundView.m
//  SellerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBackgroundView.h"

static CGFloat const alpha = 0;

@implementation CSPBackgroundView{
    UIView *_lineView;
    UIView *_backgroundView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    
    if (self.backgroundImageView == nil) {
        
        self.backgroundImageView = [[UIImageView alloc]init];
        
        self.backgroundImageView.image = [UIImage imageNamed:@"LoginBackground"];
        
        [self insertSubview:self.backgroundImageView  atIndex:0];
    }
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
    [self insertSubview:_lineView atIndex:1];
    
    _backgroundView = [[UIView alloc]init];
    _backgroundView.frame = self.frame;
    _backgroundView.alpha = alpha;
    _backgroundView.backgroundColor = [UIColor blackColor];
    [self insertSubview:_backgroundView atIndex:2];
}

- (void)layoutSubviews
{
    self.backgroundImageView.frame = self.frame;
    _lineView.frame = CGRectMake(0, 64, self.frame.size.width, 1);
    _backgroundView.frame = self.frame;
}



@end
