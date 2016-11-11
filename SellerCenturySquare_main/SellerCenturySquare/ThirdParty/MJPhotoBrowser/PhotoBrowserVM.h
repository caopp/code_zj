//
//  PhotoBrowserVM.h
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/7/23.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
@interface PhotoBrowserVM : NSObject
/*
 调用 图片浏览器 
 subview   小图图片加载View
 tag       图标签 对应 位置 起始 0
 arrimg    大图数组
 deleate   图片浏览器 滚动 调用代理 可不填
 */
- (void)tapImage:(UIImageView *)subView  withTag:(NSInteger)tag withArrayImg:(NSArray *)arrImg withMJPhotoBrowserDelegate:(id<MJPhotoBrowserDelegate>)deleate;
//数组为 uiimage
- (void)tapImageImg:(UIImageView *)subView  withTag:(NSInteger)tag withArrayImg:(NSArray *)arrImg withMJPhotoBrowserDelegate:(id<MJPhotoBrowserDelegate>)deleate withControl:(UIViewController *)controller;
@end
