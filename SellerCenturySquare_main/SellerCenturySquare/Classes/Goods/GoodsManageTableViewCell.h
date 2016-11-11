//
//  GoodsManageTableViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsMainDTO.h"

@interface GoodsManageTableViewCell : UITableViewCell

//!批发_在售 数量
@property (weak, nonatomic) IBOutlet UILabel *wholesaleNumLabel;

//!"批发_在售"
@property (weak, nonatomic) IBOutlet UILabel *wholesaleLabel;

//!零售_在售 数量
@property (weak, nonatomic) IBOutlet UILabel *retailNumLabel;

//!"零售_在售"
@property (weak, nonatomic) IBOutlet UILabel *retailLabel;

//!新发布 数量
@property (weak, nonatomic) IBOutlet UILabel *newsSaleNumLabel;


@property (weak, nonatomic) IBOutlet UILabel *newsSaleLabel;


//!分割线
@property (weak, nonatomic) IBOutlet UILabel *headerFilterLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftFilterLabel;


@property (weak, nonatomic) IBOutlet UILabel *rightFilter;


//!点击按钮的block 批发_在售:1； 零售_在售：2； 新发布:3； 全部_在售：4；
@property(nonatomic,copy) void(^intGoodsManageVC)(int);


//!初始化数据
-(void)configData:(GoodsMainDTO *)mainDTO;





@end
