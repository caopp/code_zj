//
//  EditorFreightListModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/22.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"
@class EditorFreightModel;
@interface EditorFreightListModel : BasicDTO
/**
 *  获取运费列表信息(FreightTempModel)
 */
@property(nonatomic,strong)NSMutableArray *freightTempDTOList;
// 存放实体的FreightTempModel对象
@property(nonatomic,strong)NSMutableArray *freightTempList;

@property (nonatomic,strong)EditorFreightModel *freightTempModel;
@end
