//
//  AllFreghtTemplateShow.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AllFreghtTemplateShow.h"
#import "HttpManager.h"
#import "FreightTempListModel.h"
#import "FreightTempModel.h"
static AllFreghtTemplateShow *showAll = nil;


@interface AllFreghtTemplateShow ()
//可变数组进行接受
@property (nonatomic,strong)NSMutableArray *infoListArr;

@end
@implementation AllFreghtTemplateShow


//采用单利
+(id)shareAllFreightTemplate
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        showAll = [[AllFreghtTemplateShow alloc]init];
    });
    return showAll;
}

-(void)getAllFreightTemplateData
{
    [HttpManager  sendHttpRequestForUpdateGetFreightTemplateListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        _infoListArr = [[NSMutableArray alloc]initWithCapacity:0];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            FreightTempListModel * freightTempListModel  = [[FreightTempListModel alloc]init];
            
            freightTempListModel.freightTempDTOList = [dic objectForKey:@"data"];
            
            _infoListArr = [freightTempListModel.freightTempDTOList mutableCopy];
            
            FreightTempModel *freightTempModel = [[FreightTempModel alloc]init];
            
            for (NSDictionary *dic in freightTempListModel.freightTempDTOList) {
                
                [freightTempModel setDictFrom:dic];
                
            }
            
        }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    
}



@end
