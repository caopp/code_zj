//
//  DetailWaitTakeBottomView.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
// !待收货

#import <UIKit/UIKit.h>

@interface DetailWaitTakeBottomView : UIView

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;
//!“分开多次发货 可再次上传快递单”
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;


//!拍照发货block
@property(nonatomic,copy)void(^takePhotoSenedBlock)();

//!快递单发货
@property(nonatomic,copy)void(^takeExpressSendBlock)();


@end
