//
//  NewAndModifyTemplateListModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"
@class NewAndModifyTemplateModel;
@interface NewAndModifyTemplateListModel : BasicDTO

//模版名称
@property (nonatomic,strong)NSString *templateName;
//计价方式
@property (nonatomic,strong)NSString *type;

//运费区域设置数组
@property (nonatomic,strong)NSMutableArray *setList;

////数组中model
//@property (nonatomic,strong)NewAndModifyTemplateModel *templateModel;

@end
