//
//  GoodImageDTO.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GoodImageDTO : BasicDTO

//图片id
@property (nonatomic,strong) NSNumber *Id;
//会员名称
@property (nonatomic,strong) NSString  *userName;
//图片地址
@property (nonatomic,strong) NSString  *imageUrl;
//分享时间
@property (nonatomic,strong) NSString  *createDate;
//大B是否选为默认图(1:不是,2:是)
@property (nonatomic,strong) NSNumber  *isDefault;

@end
