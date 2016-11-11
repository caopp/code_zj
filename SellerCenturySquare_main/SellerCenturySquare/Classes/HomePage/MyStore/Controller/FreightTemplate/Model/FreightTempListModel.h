//
//  FreightTempListModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"
@class  FreightTempModel;
@interface FreightTempListModel : BasicDTO

/**
 *  获取运费列表信息(FreightTempModel)
 */
@property(nonatomic,strong)NSMutableArray *freightTempDTOList;

// 存放实体的FreightTempModel对象
@property(nonatomic,strong)NSMutableArray *freightTempList;

@property (nonatomic,strong)FreightTempModel *freightTempModel;

@end
