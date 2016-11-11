//
//  DetailWaitCommitBottomView.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//  !待发货

#import <UIKit/UIKit.h>

@interface DetailWaitCommitBottomView : UIView

//!拍照发货按钮
@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;

@property (weak, nonatomic) IBOutlet UIButton *takeExpressBtn;


//!拍照发货block
@property(nonatomic,copy)void(^takePhotoSenedBlock)();

//!快递单发货
@property(nonatomic,copy)void(^takeExpressSendBlock)();


@end
