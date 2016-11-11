//
//  PhotoAndCamerSelectView.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/1/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAndCamerSelectView : UIView

//!相册
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoLeading;


@property (weak, nonatomic) IBOutlet UILabel *photoLabel;

//!相机
@property (weak, nonatomic) IBOutlet UIButton *camerBtn;

@property (weak, nonatomic) IBOutlet UILabel *camerLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *camerTrailing;


//!相册
@property(nonatomic,copy)void(^photoBlock)();
//!相机
@property(nonatomic,copy)void(^camerBlock)();


@end
