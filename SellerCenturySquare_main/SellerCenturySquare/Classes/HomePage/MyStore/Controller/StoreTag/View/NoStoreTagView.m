//
//  NoStoreTagView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "NoStoreTagView.h"
#import "UIColor+UIColor.h"

@implementation NoStoreTagView

- (IBAction)didClickAddTagButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(joinNextPage)]) {
        [self.delegate performSelector:@selector(joinNextPage)];
    }

}
-(void)awakeFromNib
{
    
    
//    self.noTagLabel.textColor = [UIColor colorWithHexValue:0xffffff alpha:1];
//    self.addTagLabel.textColor = [UIColor colorWithHexValue:0xf7f7f7 alpha:1];
//    self.addTagLabel.font = [UIFont systemFontOfSize:14];
//    
//    self.addTagButton.backgroundColor = [UIColor blackColor];
//    [self.addTagButton setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:(UIControlStateNormal)];


}

@end
