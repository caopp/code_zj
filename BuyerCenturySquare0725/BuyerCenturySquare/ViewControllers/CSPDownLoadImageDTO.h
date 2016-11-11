//
//  CSPDownLoadImageDTO.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/15.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface CSPDownLoadImageDTO : BasicDTO

@property(nonatomic,copy)NSString  *goodsNo;

/**
 *  图片列表
 */
@property(nonatomic,strong)NSMutableArray *zipsList;

- (NSMutableDictionary *)getLoadUrlWith:(NSMutableArray *)zipsList;

- (NSMutableDictionary *)getImageItemsWith:(NSMutableArray *)zipsList;


@end

@interface CSPZipsDTO : BasicDTO

@property(nonatomic,copy)NSString *zipUrl;

@property(nonatomic,copy)NSString *picType;

@property(nonatomic,copy)NSString *qty;

@property(nonatomic,copy)NSString *picSize;

@end
