//
//  NameCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//  商品名字的cell

#import <UIKit/UIKit.h>
#import "GetGoodsInfoListDTO.h"


@interface NameCell : UITableViewCell<UITextViewDelegate>
{


    GetGoodsInfoListDTO * _goodsInfoDTO;
    

}
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;

@property (weak, nonatomic) IBOutlet UITextView *goodsNameTextView;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;


//!是否在编辑
@property(nonatomic,assign)BOOL isEdit;

-(void)configData:(GetGoodsInfoListDTO *)goodsInfoDTO;


-(void)changeEditStatus;

@property(nonatomic,copy)void(^nameCellShowAlerrMessageBlock)(NSString *);


@end
