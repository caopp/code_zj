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


@property(nonatomic,copy)NSString * picListSmall;

/**
 *  图片列表
 */
@property(nonatomic,strong)NSMutableArray *zipsList;

- (NSMutableDictionary *)getLoadUrlWith:(NSMutableArray *)zipsList;
- (NSMutableDictionary *)getImageItemsWith:(NSMutableArray *)zipsList;

//!批量下载的时候使用
@property(nonatomic,assign)BOOL selectWindow;//!是否选中了串窗口图
@property(nonatomic,assign)BOOL selectObject;//!是否选中了客观图



@end

@interface CSPZipsDTO : BasicDTO

//!压缩图片路径
@property(nonatomic,copy)NSString *zipUrl;

//!图片类型：0:窗口图1:客观图
@property(nonatomic,copy)NSString *picType;

//!数量
@property(nonatomic,copy)NSString *qty;

//!大小 kb
@property(nonatomic,copy)NSString *picSize;

@end
