//
//  PromptGoodsTagView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PromptGoodsTagView.h"


@interface PromptGoodsTagView ()

@property (weak, nonatomic) IBOutlet UIButton *AddTagBtn;

- (IBAction)clickAddTagBtn:(id)sender;
@end


@implementation PromptGoodsTagView



//- (IBAction)clickAddTagBtn:(id)sender {
//    
//    if ([self.delegate respondsToSelector:@selector(PromptGoodsTagaddTag)]) {
//        [self.delegate PromptGoodsTagaddTag];
//        
//    }
//    
//}


- (IBAction)clickAddTagBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(PromptGoodsTagaddTag)]) {
        [self.delegate PromptGoodsTagaddTag];
        
    }
}
@end
