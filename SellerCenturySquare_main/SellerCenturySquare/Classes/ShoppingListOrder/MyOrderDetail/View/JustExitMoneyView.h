//
//  JustExitMoneyView.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JustExitMoneyView : UIView
/**
 *  type 0 拍照发货 1 录入快递发货 2 确定退款
 */
@property (nonatomic ,copy)void (^blockJustExitMoneyView)(NSString *type);


//拍照发货
@property (weak, nonatomic) IBOutlet UIButton *photoSendGoodsBtn;
//录入快递单发货
@property (weak, nonatomic) IBOutlet UIButton *entryExpressSingleBtn;
//确定退款
@property (weak, nonatomic) IBOutlet UIButton *makeSureExitMoneyBtn;
- (IBAction)selectPhotoSendGoodsBtn:(id)sender;
- (IBAction)selectEntryExpressSingleBtn:(id)sender;
- (IBAction)selectMakeSureExitMoneyBtn:(id)sender;

@end
