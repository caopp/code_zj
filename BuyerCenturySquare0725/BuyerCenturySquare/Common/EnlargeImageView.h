//
//  EnlargeImageView.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/1/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EnlargeImageViewDelegate <NSObject>


-(void)deleteImageView:(NSInteger )imageViewTag;

@end

@interface EnlargeImageView : UIView
{

    UIView *navView;
    
    UIView *backgroundView;
    
    UIImageView *imageView;

}

@property (nonatomic,weak)id<EnlargeImageViewDelegate>delegate;
@property(nonatomic,strong)UIButton *button;

-(void)showImage:(UIImageView *)avatarImageView  tag:(NSInteger)tag;

@end
