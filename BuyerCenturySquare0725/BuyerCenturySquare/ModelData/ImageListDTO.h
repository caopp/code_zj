//
//  ImageListDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface ImageListDTO : BasicDTO
/**
 *  图片路径
 */
@property(nonatomic,copy)NSString *picUrl;

/**
 *  图片名称
 */
@property(nonatomic,copy)NSString *picName;

/**
 *  图片类型（0:窗口图1:详情图2:参考图）
 */
@property(nonatomic,copy)NSString *picType;

/**
 *  排序（int）
 */
@property(nonatomic,copy)NSNumber *sort;

@end
