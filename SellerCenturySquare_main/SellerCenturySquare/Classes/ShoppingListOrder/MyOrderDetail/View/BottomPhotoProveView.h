//
//  BottomPhotoProveView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundApplyDTO.h"
@interface BottomPhotoProveView : UIView
@property (weak, nonatomic) IBOutlet UIView *imagePhotoView;
@property (nonatomic ,strong) RefundApplyDTO *refundApp;
@property (nonatomic ,strong) UIImageView *recrodView;

@property (nonatomic ,strong) NSArray *picsStr;

@end
