//
//  RetailModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface RetailModel : BasicDTO
//模版id
@property(nonatomic,strong)NSNumber* Id;
//是否批发模板：0不是,1是
//@property (strong,nonatomic) NSNumber *isWholesale;

////是否零售模板：0不是,1是
@property (strong,nonatomic) NSNumber *isRetail;
@end
