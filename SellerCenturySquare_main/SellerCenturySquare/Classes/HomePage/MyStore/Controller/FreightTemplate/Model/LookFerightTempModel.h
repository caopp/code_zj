//
//  LookFerightTempModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface LookFerightTempModel : BasicDTO

//地区设置id
@property(nonatomic,strong)NSNumber* Id;
//首费
@property(nonatomic,strong)NSNumber* frontFreight;
//续费
@property(nonatomic,strong)NSNumber* afterFreight;
//首重
@property(nonatomic,strong)NSNumber* frontWeight;
//续重
@property(nonatomic,strong)NSNumber* afterWeight;
//首件
@property(nonatomic,strong)NSNumber* frontQuantity;
//续件
@property(nonatomic,strong)NSNumber* afterQuantity;
//地区id
@property(nonatomic,strong)NSString *expressArea;
//是否默认运费
@property(nonatomic,strong)NSString *isDefault;
//排序序号
@property(nonatomic,strong)NSNumber* sort;











@end
