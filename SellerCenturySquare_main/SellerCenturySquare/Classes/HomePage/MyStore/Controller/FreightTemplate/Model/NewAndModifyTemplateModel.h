//
//  NewAndModifyTemplateModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface NewAndModifyTemplateModel : BasicDTO

//首费
@property (nonatomic,strong)NSNumber *frontFreight;
//续费
@property (nonatomic,strong)NSNumber *afterFreight;
//首重
@property (nonatomic,strong)NSNumber *frontWeight;
//续重
@property (nonatomic,strong)NSNumber *afterWeight;
//首件
@property (nonatomic,strong)NSNumber *frontQuantity;
//续件
@property (nonatomic,strong)NSNumber *afterQuantity;
//地区
@property (nonatomic,strong)NSString *expressArea;
//是否默认运费
@property (nonatomic,strong)NSString *isDefault;
//续号
@property (nonatomic,strong)NSNumber *sort;
//模版ID
@property (nonatomic,strong)NSNumber *templateId;
//地区id
//@property (nonatomic,strong)NSString *expressAreaId;



@end
