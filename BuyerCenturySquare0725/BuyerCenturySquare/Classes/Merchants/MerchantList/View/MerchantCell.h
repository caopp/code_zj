//
//  MerchantCell.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/1.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantListDetailsDTO.h"//!每个商家的dto

@interface MerchantCell : UICollectionViewCell
{
    
    MerchantListDetailsDTO * detailDto;
    
}
//!推荐
@property (weak, nonatomic) IBOutlet UIImageView *recommentView;

//!推荐/上新
@property (weak, nonatomic) IBOutlet UILabel *recommentLabel;

//!显示的大图
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

//!档口号
@property (weak, nonatomic) IBOutlet UILabel *merchantNumLabel;


//!店铺名称
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;


//!店铺出售类型
@property (weak, nonatomic) IBOutlet UILabel *merchantTypeLabel;


//!商品数量
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLabel;


//!特效所需灰色框
@property (weak, nonatomic) IBOutlet UIView *garyView;

//!商家歇业提示view
@property (weak, nonatomic) IBOutlet UIView *outBusinessView;

//!歇业时候显示的商家名称
@property (weak, nonatomic) IBOutlet UILabel *outBussinessNameLabel;

//!歇业时间
@property (weak, nonatomic) IBOutlet UILabel *outBussinessTimeLabel;

//!收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;


//!商家名称离顶部的位置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenterY;

//!存放档口号、数量的view的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stallNoAndNumViewWidth;


@property (weak, nonatomic) IBOutlet UIImageView *merchantStoreImageView;

@property (weak, nonatomic) IBOutlet UIImageView *goodsNumImageView;




//!收藏block
@property(nonatomic,copy) void(^collectBtnClock)();



-(void)configInfo:(MerchantListDetailsDTO *) merListDto;




@end
