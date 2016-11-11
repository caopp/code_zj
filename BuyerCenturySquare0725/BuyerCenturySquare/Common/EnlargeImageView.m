//
//  EnlargeImageView.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/1/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "EnlargeImageView.h"



static CGRect oldFrame;


@implementation EnlargeImageView

-(void)showImage:(UIImageView *)avatarImageView  tag:(NSInteger)tag

{
    
    UIImage *image=avatarImageView.image;
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    
    navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width,64)];
    navView.backgroundColor = [UIColor blackColor];
    [window addSubview:navView];
    
    
    _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 34, 33, 19, 22);
    [navView addSubview:_button];
    [_button addTarget:self action:@selector(deletedImage) forControlEvents:UIControlEventTouchUpInside];
    [_button setImage:[UIImage imageNamed:@"rubbish"] forState:(UIControlStateNormal)];
    
    
    
    //返回按钮
    UIButton *backButton = [CustomViews leftBackBtnMethod:@selector(backBarButtonClick) target:self];
    backButton.frame = CGRectMake(15, 33, 10, 18);
    [navView addSubview:backButton];
    
    
    backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    backgroundView.userInteractionEnabled = YES;
    oldFrame=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    
    backgroundView.backgroundColor=[UIColor blackColor];
    
    backgroundView.alpha=0;
    
    imageView=[[UIImageView alloc]initWithFrame:oldFrame];
    
    imageView.image=image;
    imageView.tag = tag;

    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureTop)];
    [backgroundView addGestureRecognizer:gesture];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2 - 64, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
      
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}


//触摸点击事件
-(void)gestureTop
{
    [navView removeFromSuperview];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame=oldFrame;
        
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
        
    }];


}

//返回事件
-(void)backBarButtonClick
{

    [navView removeFromSuperview];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame=oldFrame;
        
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
        
    }];

    
}



-(void)deletedImage
{
    
    
    if ([self.delegate respondsToSelector:@selector(deleteImageView:)]) {
        
        [self.delegate deleteImageView:imageView.tag];
    }
    
    
    [navView removeFromSuperview];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame=oldFrame;
        
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
        
    }];

   
}


@end
