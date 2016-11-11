//
//  CominedShippingBottomView.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CominedShippingDelegate <NSObject>
/**
 *  合并拍照发货
 */
- (void)cominedShippingMergePictures;
/**
 *  录入快递单发货
 */
- (void)cominedShippingEntryExpress;

@end
@interface CominedShippingBottomView : UIView

@property (nonatomic ,assign) id<CominedShippingDelegate>delegat;

@property (weak, nonatomic) IBOutlet UIButton *mergePictureBtn;
@property (weak, nonatomic) IBOutlet UIButton *entryExpressBtn;

/**
 *  合并拍照发货
 *
 *  @param sender
 */
- (IBAction)selectMergePicturesBtn:(id)sender;
/**
 *  录入快递单发货
 *
 *  @param sender
 */
- (IBAction)selectEntryExpressBtn:(id)sender;

@end

