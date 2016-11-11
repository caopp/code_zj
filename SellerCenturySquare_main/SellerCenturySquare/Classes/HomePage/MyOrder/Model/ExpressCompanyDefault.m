//
//  ExpressCompanyDefault.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ExpressCompanyDefault.h"


static ExpressCompanyDefault * manager = nil;


@implementation ExpressCompanyDefault

+(id)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ExpressCompanyDefault alloc]init];
        
    });
    
    return manager;
    
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        //!快递公司
        NSString * companyPath = [NSString stringWithFormat:@"%@/Documents/compayData.plist",NSHomeDirectory()];
        
        self.compayDataArray = [NSMutableArray arrayWithContentsOfFile:companyPath];
        
        if (self.compayDataArray == nil) {
            
            self.compayDataArray  =[NSMutableArray arrayWithCapacity:0];
        }
        
        //!快递公司首字母集合
        NSString * titlePath = [NSString stringWithFormat:@"%@/Documents/titleData.plist",NSHomeDirectory()];
        
        self.firstTitleDataArray = [NSMutableArray arrayWithContentsOfFile:titlePath];
        
        if (self.firstTitleDataArray == nil) {
            
            self.firstTitleDataArray = [NSMutableArray arrayWithCapacity:0];
            
        }
        
    }
    
    
    
    return self;
}

-(void)Data_Save{
    
    //!快递公司
    NSString * companyPath = [NSString stringWithFormat:@"%@/Documents/compayData.plist",NSHomeDirectory()];
    
    [self.compayDataArray writeToFile:companyPath atomically:YES];
    
    
    //!快递公司首字母集合
    NSString * titlePath = [NSString stringWithFormat:@"%@/Documents/titleData.plist",NSHomeDirectory()];
    
    [self.firstTitleDataArray writeToFile:titlePath atomically:YES];
    
}



@end
