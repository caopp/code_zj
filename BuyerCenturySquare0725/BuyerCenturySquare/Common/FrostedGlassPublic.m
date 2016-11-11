//
//  FrostedGlassPublic.m
//  BuyerCenter
//
//  Created by 张晓旭 on 15/10/14.
//  Copyright © 2015年 左键视觉. All rights reserved.
//

#import "FrostedGlassPublic.h"
#import "UIImage+ImageEffects.h"
@implementation FrostedGlassPublic
+(void)settingBackgroungFrostedGlassImage:(NSString *)image  imageView:(UIImageView *)imageView
{
    
    
    UIImage *img = [UIImage imageNamed:image];
    
    [imageView setImage:[img applyBlurWithRadius:15
                                       tintColor:[UIColor colorWithWhite:0 alpha:0.2]
                           saturationDeltaFactor:1.8
                                       maskImage:nil]];
    
    
}
@end
