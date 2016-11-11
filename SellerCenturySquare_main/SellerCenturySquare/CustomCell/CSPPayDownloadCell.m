//
//  CSPPayDownloadCell.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPPayDownloadCell.h"
#import "SingleSku.h"
@implementation CSPPayDownloadCell

- (void)awakeFromNib{
    
    self.skuControllView.title = @"数量";
    
    self.skuControllView.style = CSPSkuControlViewStyleSingleCounter;
}

@end
