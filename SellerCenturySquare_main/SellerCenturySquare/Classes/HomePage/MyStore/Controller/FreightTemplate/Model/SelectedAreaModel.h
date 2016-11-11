//
//  SelectedAreaModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface SelectedAreaModel : BasicDTO

//id
@property(nonatomic,strong)NSNumber* Id;
//父级ID
@property(nonatomic,strong)NSNumber* parentId;
//地区名称
@property (strong,nonatomic) NSString *name;
//排序
@property (strong,nonatomic) NSNumber *sort;
////级别类型2省份、3市区、4区县
@property (strong,nonatomic) NSString *type;






@end
