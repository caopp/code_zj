//
//  ImgDTO.h
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/28.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "BasicDTO.h"

@interface ImgDTO : BasicDTO
@property (nonatomic,strong)NSString *picUrl;//	String	图片路径
@property (nonatomic,strong)NSString *picMax;//	String	大图链接
@property (nonatomic,strong)NSString *isRef;//	String	是否窗口-参考图(0:不是 1:是)
-(void)setDictFrom:(NSDictionary *)dictInfo;
@end
