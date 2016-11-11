//
//  CSPGoodsTableViewCell.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "EditGoodsDTO.h"
#import "GetGoodsInfoListDTO.h"

@interface CSPGoodsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsimageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *vipPriceView;

//!“颜色”
@property (weak, nonatomic) IBOutlet UILabel *goodsColorTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsColorLabel;

//!中间的分割线
@property (weak, nonatomic) IBOutlet UILabel *centeFilterLabel;
//!中间分割线的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerFilterHight;


//!底部的分割线
@property (weak, nonatomic) IBOutlet UILabel *bottomFilterLabel;


@property (weak, nonatomic) IBOutlet UIButton *groundingButton;

//!价格view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceViewHight;

//!“第一次上架时间:”
@property (weak, nonatomic) IBOutlet UILabel *firstOnSaleTitleLabel;




// !上架、下架
@property (copy,nonatomic)void(^goodsStatusOperation)(NSString *goodsNo,NSString *goodsStatus);

//!“销售类型”
@property (weak, nonatomic) IBOutlet UILabel *saleTypeLabel;

//!批发
@property (weak, nonatomic) IBOutlet UILabel *wholesaleLabel;

//!零售
@property (weak, nonatomic) IBOutlet UILabel *retailLabel;


// !商家歇业和关闭的时候不能上架商品 把原因传回去
@property(nonatomic,copy)void(^cannotChangeStatus)(NSString *reason);



@property (copy,nonatomic)NSString *goodsNo;
@property (copy,nonatomic)NSString *goodsStatus;

// !是否是未发布tableView 的cell
@property(nonatomic,assign)BOOL  isNotPublish;

//!处理数据
-(void)configData:(EditGoodsDTO *)editGoodsDTO;

//!cell的高度
@property(nonatomic,assign)float cellHight;


@end
