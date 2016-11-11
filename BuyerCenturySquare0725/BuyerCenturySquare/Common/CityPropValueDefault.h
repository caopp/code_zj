//
//  CityPropValueDefault.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/5/9.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityPropValueDefault : NSObject

//省市区集合
@property (nonatomic,strong)NSMutableArray *cityArr;

//获取单单例，得到数据
+(id)shareManager;
//进行数据版本控制
-(void)dataPropValueControl;
@end
