//
//  AttrDTO.h
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/28.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "BasicDTO.h"

@interface AttrDTO : BasicDTO
@property (nonatomic,strong)NSString *attrId;
@property (nonatomic,strong)NSString *attrName;
@property (nonatomic,strong)NSString *attrValText;
-(void)setDictFrom:(NSDictionary *)dictInfo;
@end
