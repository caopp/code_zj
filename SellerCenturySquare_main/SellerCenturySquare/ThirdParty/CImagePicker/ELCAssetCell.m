//
//  AssetCell.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCConsole.h"
#import "ELCOverlayImageView.h"
#import "EnlargeImageModel.h"
#import "UIColor+UIColor.h"
#define imageWidth  (self.bounds.size.width - 20)/4


@interface ELCAssetCell ()
{
    UIImageView *iconImage;
}
@property (nonatomic, strong) NSArray *rowAssets;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *overlayViewArray;

@property (nonatomic, strong) NSMutableArray *stealthViweArray;

@end

@implementation ELCAssetCell

//Using auto synthesizers
//进行初始化cell 对应的
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if (self) {
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.imageViewArray = mutableArray;
        
        NSMutableArray *overlayArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.overlayViewArray = overlayArray;
        
        self.alignmentLeft = YES;
	}
	return self;
}

//进行图片设置，以及图片上的添加其他的事项的操作
- (void)setAssets:(NSArray *)assets
{
    //获取到图片的个数
    self.rowAssets = assets;
    
    //以下两个for对视图的处理
	for (UIImageView *view in _imageViewArray) {
        [view removeFromSuperview];
	}
    for (ELCOverlayImageView *view in _overlayViewArray) {
        [view removeFromSuperview];
	}
   
    UIImage *overlayImage = nil;
    
    

    //计算获取到的图片的个数进行初六
    for (int i = 0; i < [_rowAssets count]; ++i) {
        //对相对应的图片进行处理
        ELCAsset *asset = [_rowAssets objectAtIndex:i];

#pragma mark -----对图片的处理----

        
        //图片进行展示（对展示的图片进行判断）
        if (i < [_imageViewArray count]){
            
            UIImageView *imageView = [_imageViewArray objectAtIndex:i];
            imageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
            
        } else {
            
            //先进入这个方法，在把所得到的个数添加到数组中去
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.asset.thumbnail]];
            [_imageViewArray addObject:imageView];
        }
        
        
        
        
    
        //现在处理的是覆盖的图片
        if (i < [_overlayViewArray count]) {
            
            ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
            overlayView.hidden = asset.selected ? NO : YES;
            overlayView.labIndex.text = [NSString stringWithFormat:@"%d", asset.index + 1];
        }
        else {
            
            ELCOverlayImageView *overlayView = [[ELCOverlayImageView alloc] initWithImage:overlayImage];
            [_overlayViewArray addObject:overlayView];
            overlayView.hidden = asset.selected ? NO : YES;
            overlayView.labIndex.text = [NSString stringWithFormat:@"%d", asset.index + 1];
        }
        
    }
}
//从这里可以看出是两个数组之间视图的转化。

//点击图片出现的效果
- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    //点击后出现UI显示变化。
    //触摸的范围（触摸的范围）
    
    CGPoint point = [tapRecognizer locationInView:self];
    
    int c = (int32_t)self.rowAssets.count;
    
    CGFloat totalWidth = c * imageWidth + (c - 1) * 4;
    
    CGFloat startX;
    
    if (self.alignmentLeft) {
        startX = 4;
    }else {
        startX = (self.bounds.size.width - totalWidth) / 2;
    }
    
	CGRect frame = CGRectMake(0, 10, imageWidth, imageWidth);
	
    
	for (int i = 0; i < [_rowAssets count]; ++i) {
        if (CGRectContainsPoint(frame, point)) {
            //进行标记，添加到数组当中
            ELCAsset *asset = [_rowAssets objectAtIndex:i];
            
            asset.selected = !asset.selected;
            //对显示的图片进行设置（也把显示的个数添加图片当中）
            ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
        
            overlayView.hidden = !asset.selected;
            
            //选中后，进行显示添加的个数
            if (asset.selected) {
                
                asset.index = [[ELCConsole mainConsole] numOfSelectedElements];
                //图片显示添加的个数
                [overlayView setIndex:asset.index+1];
                
                [[ELCConsole mainConsole] addIndex:asset.index];
                
            }
            else
            {
                                
                //进行不显示的，采用的减1的方式（进行移除）
                int lastElement = [[ELCConsole mainConsole] numOfSelectedElements] - 1;
                [[ELCConsole mainConsole] removeIndex:lastElement];
            }
            
            NSLog(@"%d",[[ELCConsole mainConsole] numOfSelectedElements]);
            
            [self.delegate ELCAssetCellShowSelectNub:[NSString stringWithFormat:@"%d",[[ELCConsole mainConsole] numOfSelectedElements]]];
            
            break;
        }
        frame.origin.x = frame.origin.x + frame.size.width + 4;
    }
}



//重新开始布局
- (void)layoutSubviews
{
    
    if (self.rowAssets.count != 0) {
        int c = (int32_t)self.rowAssets.count;
        CGFloat totalWidth = c * imageWidth + (c - 1) * 4;
        CGFloat startX;
        
        if (self.alignmentLeft) {
            startX = 4;
        }else {
            startX = (self.bounds.size.width - totalWidth) / 2;
        }
        
        CGRect frame = CGRectMake(startX, 4, imageWidth, imageWidth);
        
        
        //重新布局
        for (int i = 0; i < [_rowAssets count]; ++i) {
            UIImageView *imageView = [_imageViewArray objectAtIndex:i];
            [imageView setFrame:frame];
            
            //进行添加，进行图标显示
//            iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(65, 5, 20, 20)];
//            iconImage.image = [UIImage imageNamed:@"Ô"];
//            iconImage.backgroundColor = [UIColor whiteColor];
//            iconImage.layer.cornerRadius = 10;
//            iconImage.layer.masksToBounds = YES;
//            [imageView addSubview:iconImage];
            if (imageView.subviews.count !=0) {
                for (UIView *v  in imageView.subviews) {
                    [v removeFromSuperview];
                    
                }
            }
            
            
            UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(imageView.frame.size.width - 20, 5, 20, 20)];
            iconView.layer.cornerRadius = 21.0/2;
            iconView.layer.masksToBounds = YES;
            
            iconView.backgroundColor = [UIColor colorWithHexValue:0xffffff alpha:0.2];
            iconView.layer.borderColor = [UIColor colorWithHexValue:0xffffff alpha:1].CGColor;
            iconView.layer.borderWidth = 1;
            
            [imageView addSubview:iconView];
            
            
            [self addSubview:imageView];
            
            ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
            [overlayView setFrame:frame];
            
            [overlayView changeFrame];

            [self addSubview:overlayView];
            
            frame.origin.x = frame.origin.x + frame.size.width + 4;
        }

    }
    
}


@end
