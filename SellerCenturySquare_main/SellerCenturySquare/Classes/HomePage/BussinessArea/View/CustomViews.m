//
//  CustomViews.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 15/12/15.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "CustomViews.h"

@implementation CustomViews

#pragma mark 左导航返回按钮

+(UIButton *)leftBackBtnMethod:(SEL)sel target:(id)target
{
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 10, 18);
    [leftBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateSelected];
    [leftBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return leftBtn;
    


}
@end
