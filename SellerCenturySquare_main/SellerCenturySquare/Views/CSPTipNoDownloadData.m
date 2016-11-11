//
//  CSPTipNoDownloadData.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPTipNoDownloadData.h"

@implementation CSPTipNoDownloadData

- (IBAction)buyDownloadMoreImageButtonClick:(id)sender {
    
    self.buyMoreImageBlock();
}

- (void)isImageHidden:(BOOL)hidden{
    
    [self viewWithTag:101].hidden = hidden;
    [self viewWithTag:102].hidden = hidden;

}

- (void)showView:(UIView *)view{
    
    if (view == self.tipNoDownloadDataView) {
        
        self.tipNoDownloadDataView.hidden = NO;
        
        self.tipNoDownloadingDataView.hidden = YES;
        
        self.tipEmptyDataView.hidden = YES;
        
        [self isImageHidden:NO];
        
    }else if (view == self.tipNoDownloadingDataView){
        
        self.tipNoDownloadDataView.hidden = YES;
        
        self.tipNoDownloadingDataView.hidden = NO;
        
        self.tipEmptyDataView.hidden = YES;
        
        [self isImageHidden:YES];
    
    }else if (view == self.tipEmptyDataView){
        
        self.tipNoDownloadDataView.hidden = YES;
        
        self.tipNoDownloadingDataView.hidden = YES;
        
        self.tipEmptyDataView.hidden = NO;
        
        [self isImageHidden:NO];
    }
}
@end
