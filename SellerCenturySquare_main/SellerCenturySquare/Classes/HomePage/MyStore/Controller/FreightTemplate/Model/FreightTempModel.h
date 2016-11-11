//
//  FreightTempModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface FreightTempModel : BasicDTO

//模版id
@property(nonatomic,strong)NSNumber* Id;
//是否默认模板:0默认,1不是默认,2系统默认
@property (strong,nonatomic) NSString *isDefault;
//模版名称
@property (strong,nonatomic) NSString *templateName;
//计价方式:0按重量,1按件数
@property (strong,nonatomic) NSString *type;
//是否批发模板：0不是,1是
@property (strong,nonatomic) NSNumber *isWholesale;
//是否批发默认模板：0不是,1是
@property (strong,nonatomic) NSNumber *isWholesaleDefault;
//是否零售模板：0不是,1是
@property (strong,nonatomic) NSNumber *isRetail;
//是否零售默认模板：0不是,1是
@property (strong,nonatomic) NSNumber *isRetailDefault;

@property (strong,nonatomic) NSString *sysDefault;

@end
