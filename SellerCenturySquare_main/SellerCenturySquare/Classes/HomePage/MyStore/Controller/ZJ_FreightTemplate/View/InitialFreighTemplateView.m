//
//  InitialFreighTemplateView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "InitialFreighTemplateView.h"
#import "UIColor+UIColor.h"

@implementation InitialFreighTemplateView

-(void)awakeFromNib
{
    //介绍
    [self.introductionLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    self.chooseButton.layer.masksToBounds = YES;
    self.chooseButton.layer.cornerRadius = 2;
    [self.chooseButton setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:(UIControlStateNormal)];
    self.chooseButton.backgroundColor = [UIColor blackColor];

}
- (IBAction)didClickChooseButtonAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(showAllFreightTemplate)]) {
        [self.delegate performSelector:@selector(showAllFreightTemplate)];
    }
    
}
@end
