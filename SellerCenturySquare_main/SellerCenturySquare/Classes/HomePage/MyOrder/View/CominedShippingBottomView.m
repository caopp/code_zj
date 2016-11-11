 //
//  CominedShippingBottomView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CominedShippingBottomView.h"

@implementation CominedShippingBottomView
-(void)awakeFromNib
{
    
    self.mergePictureBtn.titleLabel.numberOfLines = 1;

    [self.mergePictureBtn.titleLabel sizeToFit];

    [self.mergePictureBtn.titleLabel adjustsFontSizeToFitWidth];
    self.entryExpressBtn.titleLabel.numberOfLines = 1;
    [self.entryExpressBtn.titleLabel sizeToFit];

    [self.entryExpressBtn.titleLabel adjustsFontSizeToFitWidth];
    
}

- (IBAction)selectMergePicturesBtn:(id)sender {
    if ([self.delegat respondsToSelector:@selector(cominedShippingMergePictures)]) {
        [self.delegat cominedShippingMergePictures];
    }
    
}

- (IBAction)selectEntryExpressBtn:(id)sender {
    if ([self.delegat respondsToSelector:@selector(cominedShippingEntryExpress)]) {
        [self.delegat cominedShippingEntryExpress];
        
    }
    
}
@end
