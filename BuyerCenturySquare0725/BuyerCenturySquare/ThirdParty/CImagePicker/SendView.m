//
//  SendView.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/12.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "SendView.h"
#import "UIColor+UIColor.h"
@implementation SendView


-(void)awakeFromNib
{

//    @property (strong, nonatomic) IBOutlet UIButton *sendButton;
//    
//    @property (strong, nonatomic) IBOutlet UIButton *previewButton;
    
    [self.sendButton setTintColor:[UIColor blackColor]];
    [self.previewButton setTintColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    if (self.isBusiness) {
        
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didclickpreviewImage)];
    [self.previewImage addGestureRecognizer:tap];
    self.previewImage.userInteractionEnabled = YES;
    
    
    
    self.numberLabel.backgroundColor = [UIColor colorWithHexValue:0xeb301f alpha:1];
    self.numberLabel.layer.masksToBounds = YES;
    self.numberLabel.layer.cornerRadius = self.numberLabel.frame.size.width/2;
    
    
    

}

- (void)didclickpreviewImage
{
    NSLog(@"点我了");
    
    
    if ([self.delegate respondsToSelector:@selector(didClickPreviewButtonAction)]) {
        [self.delegate performSelector:@selector(didClickPreviewButtonAction)];
    }

    
}

//******原先的方法***********
//- (IBAction)didClickSendButtonAction:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(didClickSendViewAction)]) {
//        [self.delegate performSelector:@selector(didClickSendViewAction)];
//    }
//    
//}
//- (IBAction)didClickPreviewButtonAciton:(id)sender {
//    
//    if ([self.delegate respondsToSelector:@selector(didClickPreviewButtonAction)]) {
//        [self.delegate performSelector:@selector(didClickPreviewButtonAction)];
//    }
//}

@end
