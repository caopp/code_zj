//
//  CourierListModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface CourierListModel : BasicDTO

//
@property (nonatomic,copy)NSString *callBack;
//
@property (nonatomic,copy)NSString *createDate;
//物流运单号
@property (nonatomic,copy)NSString *logisticCode;
//快递公司编码
@property (nonatomic,copy)NSString *shipperCode;
//物流状态: 2-在途中，3-签收,4-问题件
@property (nonatomic,copy)NSString *state;

/**
 *  获取采购单列表
 */
@property(nonatomic,strong)NSMutableArray *courierListDTOList;

// 存放实体的采购单model对象
@property(nonatomic,strong)NSMutableArray *CourierListList;

@end
