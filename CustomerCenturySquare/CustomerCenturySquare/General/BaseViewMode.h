//
//  BaseViewMode.h
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/9.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseViewMode : NSObject
@property (strong, nonatomic) ReturnValueBlock returnBlock;
@property (strong, nonatomic) ErrorCodeBlock errorBlock;
@property (strong, nonatomic) FailureBlock failureBlock;
// 传入交互的Block块
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock;
@end
