//
//  LookFerightTempListModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface LookFerightTempListModel : BasicDTO

//设置两个可变数组
@property (nonatomic,strong)NSMutableArray *lookFerightTempDTOList;

@property (nonatomic,strong)NSMutableArray *lookFerightTempList;


//计价方式:0按重量,1按件数
@property (nonatomic,strong)NSString *type;
//运费模版名字
@property (nonatomic,strong)NSString *templateName;

@end
