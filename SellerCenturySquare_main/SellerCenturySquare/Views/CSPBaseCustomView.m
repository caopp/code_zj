//
//  CSPBaseCustomView.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

@implementation CSPBaseCustomView

- (void)tipNotOperation{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"子账号不可执行上架、下架操作" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

@end
