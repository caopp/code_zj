//
//  BottomPhotoProveView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BottomPhotoProveView.h"
#import "UUImageAvatarBrowser.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "Masonry.h"
#import "MJPhotoBrowser.h"
@implementation BottomPhotoProveView
 - (void)awakeFromNib
{
    
}
- (void)setRefundApp:(RefundApplyDTO *)refundApp
{
    if (refundApp) {
//        for (NSString *refund in refundApp.pics) {
//            NSLog(@"%@",refund);
//        }
        NSArray *picsStr = [refundApp.pics componentsSeparatedByString:@","];
        NSLog(@"%@",picsStr);
        self.picsStr = picsStr;
        
        CGFloat viewWidth = self.imagePhotoView.frame.size.width;
        int recordIntX = 0;
        int recordIntY = 0;
        CGFloat recordImageX = 0.0;
        CGFloat recordImageY = 0.0;
        UIImageView *recordImage;
        
        for (int i = 0; i < picsStr.count; i++) {
     
            if (recordImageX>viewWidth) {
                recordIntX = 0;
                recordIntY++;
            }
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(80*recordIntX, 80*recordIntY, 70, 70)];
            
            image.tag = 1000+i;

            recordIntX++;
            recordImage = image;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageTap:)];
            
            image.userInteractionEnabled = YES;
            [image addGestureRecognizer:tap];

            [self.imagePhotoView addSubview:image];
            
            image.clipsToBounds = YES;
            image.contentMode = UIViewContentModeScaleAspectFill;
            
            
            recordImageX = CGRectGetMaxX(recordImage.frame);
            recordImageY = CGRectGetMaxY(recordImage.frame);
            
            [image sd_setImageWithURL:[NSURL URLWithString:picsStr[i]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];

        }
    }
}

- (void)showImageTap:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIImageView *tapImage = (UIImageView *)tap.view;
//    [UUImageAvatarBrowser showImage:tapImage];
    
    NSMutableArray *photos = [NSMutableArray array];
    
    
    if (self.picsStr.count>0) {
       
        
        for (int i=0; i<self.picsStr.count; i++) {
            NSString *url = self.picsStr[i];
            
            MJPhoto*photo  = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url];
            UIImageView *imageV = (UIImageView *)[self.imagePhotoView viewWithTag:i+1000];
            photo.srcImageView = imageV;
            
            [photos addObject:photo];
            

            
        }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag-1000; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
    
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