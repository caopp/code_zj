//
//  MerchantDeatilNavView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/2.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantDeatilNavView : UIView

//!显示的图片
@property (weak, nonatomic) IBOutlet UIImageView *showImgeView;

//!商家名称
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;

//!店铺介绍
@property (weak, nonatomic) IBOutlet UIButton *merchantIntroduceBtn;

//!商品分类
@property (weak, nonatomic) IBOutlet UIButton *merchantCategoryBtn;

//!邮费专拍
@property (weak, nonatomic) IBOutlet UIButton *postageBtn;

//!客服按钮
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;


@property (weak, nonatomic) IBOutlet UIButton *collectBtn;


//!返回block
@property(nonatomic,copy)void(^backBlock)();

//!店铺介绍block
@property(nonatomic,copy)void(^merchantIntroduceBlock)();

//!商品分类block
@property(nonatomic,copy)void(^merchantCategoryBlock)();

//!邮费专拍block
@property(nonatomic,copy)void(^postageBlock)();

//!客服按钮
@property(nonatomic,copy)void(^serviceBtnBlock)();

//!收藏按钮
@property(nonatomic,copy)void(^collectBtnBlock)();



@end
