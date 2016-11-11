//
//  FreightplateMailView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "FreightplateMailView.h"

@implementation FreightplateMailView

- (IBAction)selctedButtonAction:(id)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(selectedBtn:)]) {
        
        [self.delegate selectedBtn:self.selectedBtn];
    }
    
}

@end
