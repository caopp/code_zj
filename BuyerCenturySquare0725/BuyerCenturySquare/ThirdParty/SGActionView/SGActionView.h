//
//  SGActionMenu.h
//  SGActionView
//
//  Created by Sagi on 13-9-3.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSGActionViewDismissNotification @"SGActionViewDismissNotification"
// !下载通知
#define kSGActionViewDownload @"kSGActionViewDownload"
/**
 *  弹出框样式
 */
typedef NS_ENUM(NSInteger, SGActionViewStyle){
    SGActionViewStyleLight = 0,     // 浅色背景，深色字体
    SGActionViewStyleDark           // 深色背景，浅色字体
};

typedef void(^SGMenuActionHandler)(BOOL isWindow, BOOL isImper );

@interface SGActionView : UIView


/**
 *  弹出框样式
 */
@property (nonatomic, assign) SGActionViewStyle style;

/**
 *  获取单例
 */
+ (SGActionView *)sharedActionView;

+ (UIView*)showDownloadView:(NSMutableArray *)array;




@end
