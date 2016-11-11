//
//  BaseViewMode.m
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/9.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "BaseViewMode.h"

@implementation BaseViewMode
#pragma 接收穿过来的block
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock
{
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
    _failureBlock = failureBlock;
}

@end
