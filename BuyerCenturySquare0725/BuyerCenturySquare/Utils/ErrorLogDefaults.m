//
//  ErrorLogDefaults.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/4/9.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ErrorLogDefaults.h"

static ErrorLogDefaults * defaults = nil;

@implementation ErrorLogDefaults

+(id)shareManager{


    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        defaults = [[ErrorLogDefaults alloc]init];
        
    });


    return defaults;

}
-(instancetype)init{

    if (self = [super init]) {

        //!错误日志
        NSString * errorLogPath = [NSString stringWithFormat:@"%@/Documents/buyerErrorLog.plist",NSHomeDirectory()];
        
        self.errorLogArray = [NSMutableArray arrayWithContentsOfFile:errorLogPath];
        
        if (self.errorLogArray == nil) {
            
            self.errorLogArray  =[NSMutableArray arrayWithCapacity:0];
        }
        
        
    }

    return self;
}
//!保存
-(void)errorLog_save{

    //!错误日志
    NSString * errorLogPath = [NSString stringWithFormat:@"%@/Documents/buyerErrorLog.plist",NSHomeDirectory()];

    [self.errorLogArray writeToFile:errorLogPath atomically:YES];

}

//!删除已经上传的plist数据
-(void)removePlistInfo{

    //!错误日志
    NSString * errorLogPath = [NSString stringWithFormat:@"%@/Documents/buyerErrorLog.plist",NSHomeDirectory()];
    
    [self.errorLogArray removeAllObjects];

    [self.errorLogArray writeToFile:errorLogPath atomically:YES];


}
@end
