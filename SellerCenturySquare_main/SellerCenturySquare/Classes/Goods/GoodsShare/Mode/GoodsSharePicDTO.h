//
//  GoodsSharePicDTO.h
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GoodsSharePicDTO : BasicDTO
@property(nonatomic,strong)NSString *imageUrl;//	String	图片地址
@property(nonatomic,strong)NSNumber *imageType;//	int	图片类型：1窗口图,2参考图
@end
