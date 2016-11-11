//
//  PhotoBrowserVM.m
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/7/23.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "PhotoBrowserVM.h"
#import "ImgDTO.h"

@implementation PhotoBrowserVM
- (void)tapImage:(UIImageView *)subView  withTag:(NSInteger)tag withArrayImg:(NSArray *)arrImg withMJPhotoBrowserDelegate:(id<MJPhotoBrowserDelegate>)deleate
{
    
    
    
    
    //NSDictionary *getReferenceImagesDic = _showObjectiveImage?objectiveImagesDic:referenceImagesDic;
    NSInteger count =  arrImg.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        ImgDTO *imgDTO = [arrImg objectAtIndex:i];
        
        NSString *urlStr = (imgDTO.picMax&&[imgDTO.picMax length])?imgDTO.picMax:imgDTO.picUrl;
        // 替换为中等尺寸图片
        NSURL *url = [NSURL URLWithString:urlStr];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = url; // 图片路径
        photo.srcImageView = subView; // 来源于哪个UIImageView
        [photos addObject:photo];
        
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.delegate = deleate;
    [browser show];
}
//数组为 uiimage
- (void)tapImageImg:(UIImageView *)subView  withTag:(NSInteger)tag withArrayImg:(NSArray *)arrImg withMJPhotoBrowserDelegate:(id<MJPhotoBrowserDelegate>)deleate withControl:(UIViewController *)controller
{
 
    //NSDictionary *getReferenceImagesDic = _showObjectiveImage?objectiveImagesDic:referenceImagesDic;
    NSInteger count =  arrImg.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        UIImage *img = [arrImg objectAtIndex:i];
        
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image = img; // 图片路径
        photo.srcImageView = subView; // 来源于哪个UIImageView
        [photos addObject:photo];
        
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.delegate = deleate;
    [controller.navigationController pushViewController:browser animated:YES];
//    UIView *viewBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
//    viewBar.backgroundColor = [UIColor redColor];
//    [browser.view addSubview:viewBar];
//    
//    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 45)];
//    [viewBar addSubview:btnBack];
//    
//    
//    UIButton *btnDeleate = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 20, 60, 45)];
//    [viewBar addSubview:btnDeleate];
    

}

@end
