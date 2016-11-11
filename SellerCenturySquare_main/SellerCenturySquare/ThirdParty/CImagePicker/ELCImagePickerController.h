//
//  ELCImagePickerController.h
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAssetSelectionDelegate.h"

@class ELCImagePickerController;
@class ELCAlbumPickerController;

@protocol ELCImagePickerControllerDelegate <UINavigationControllerDelegate>

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker;

@end

@interface ELCImagePickerController : UINavigationController <ELCAssetSelectionDelegate>

@property (nonatomic, weak) id<ELCImagePickerControllerDelegate> imagePickerDelegate;
//个数
@property (nonatomic, assign) NSInteger maximumImagesCount;
@property (nonatomic, assign) BOOL onOrder;
/**
*表示数组访问的媒体的媒体类型选择器控制器。* UIImagePickerController用法一样。
 */
@property (nonatomic, strong) NSArray *mediaTypes;

/**
 *是的如果选择应该返回一个用户界面图像以及其他元信息(这是默认的),*如果选择不应该返回assetURL等元信息,但没有实际的用户界面图像。 */
@property (nonatomic, assign) BOOL returnsImage;

/**
 *是的如果选择应该返回原始图像,*或没有一个适合在设备上显示全屏图像。*没有“returnsImage”如果没有。
 */
@property (nonatomic, assign) BOOL returnsOriginalImage;

//初始化
- (id)initImagePicker;
//取消
- (void)cancelImagePicker;

@end

