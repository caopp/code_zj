//
//  SearchMerchantCell.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/22.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchMerhantDTO.h"




@interface SearchMerchantCell : UICollectionViewCell
{

    SearchMerhantDTO * merchantDTOs;

}
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (weak, nonatomic) IBOutlet UIView *grayView;

@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;

@property (weak, nonatomic) IBOutlet UIView *tagsView;

@property (weak, nonatomic) IBOutlet UIView *addressAndGoodsNumView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodNumLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewRight;



@property(nonatomic,strong)UIScrollView * goodsSC;

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;



//!点击事件的block 传过去点击的dto、点击的是否是最后一个 按钮,商家编码
@property(nonatomic,copy) void(^selectGoodsBlock)(TenNumGoodsDTO * ,BOOL,NSString *) ;


-(void)configData:(SearchMerhantDTO *)merhantDTO;

//!收藏block
@property(nonatomic,copy) void(^collectBtnClock)();


@end
