//
//  ELCOverlayImageView.m
//  ELCImagePickerDemo
//
//  Created by Seamus on 14-7-11.
//  Copyright (c) 2014年 ELC Technologies. All rights reserved.
//

#import "ELCOverlayImageView.h"
#import "ELCConsole.h"
@implementation ELCOverlayImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setIndex:(int)_index
{
    self.labIndex.text = [NSString stringWithFormat:@"%d",_index];
}

- (void)dealloc
{
    self.labIndex = nil;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        UIImageView *img = [[UIImageView alloc] initWithImage:image];
        [self addSubview:img];
        if ([[ELCConsole mainConsole] onOrder]) {
            
            UIView *iconView = [[UIView alloc]initWithFrame:CGRectMake(65, 5, 20, 20)];
            iconView.layer.cornerRadius = 20.0/2;
            iconView.layer.masksToBounds = YES;
//            iconView.backgroundColor = [UIColor whiteColor];
            iconView.layer.borderColor = [UIColor blackColor].CGColor;
            iconView.layer.borderWidth = 1;
            iconView.tag = 1000;

            
            UIImageView *iconImage = [[UIImageView alloc]initWithFrame:iconView.bounds];
            iconImage.image = [UIImage imageNamed:@"selected_photo"];
            [iconView addSubview:iconImage];
            iconImage.tag = 2000;

            [self addSubview:iconView];
            
//            self.labIndex = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width -5, 5, 16, 16)];
//            self.labIndex.backgroundColor = [UIColor redColor];
//            self.labIndex.clipsToBounds = YES;
//            self.labIndex.textAlignment = NSTextAlignmentCenter;
//            self.labIndex.textColor = [UIColor whiteColor];
//            self.labIndex.layer.cornerRadius = 8;
//            self.labIndex.layer.shouldRasterize = YES;
//            //        self.labIndex.layer.borderWidth = 1;
//            //        self.labIndex.layer.borderColor = [UIColor greenColor].CGColor;
//            self.labIndex.font = [UIFont boldSystemFontOfSize:13];
//            [self addSubview:self.labIndex];
        }
    }
    return self;
}
-(void)changeFrame{
    
    UIView * iconView = [self viewWithTag:1000];
    iconView.frame = CGRectMake(self.frame.size.width - 20, 5 , 20, 20);
    
    UIView * iconImageView = [self viewWithTag:2000];
    iconImageView.frame = iconView.bounds;
    
    
    
}




@end
