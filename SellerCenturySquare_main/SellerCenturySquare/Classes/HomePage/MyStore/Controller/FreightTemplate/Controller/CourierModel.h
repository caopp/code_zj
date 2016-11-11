//
//  CourierModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface CourierModel : BasicDTO

//轨迹ID
@property (nonatomic,copy)NSNumber *Id;
//轨迹时间
@property (nonatomic,copy)NSString *acceptTime;
//描述
@property (nonatomic,copy)NSString *acceptStation;
//备注
@property (nonatomic,copy)NSString *remark;

@end
