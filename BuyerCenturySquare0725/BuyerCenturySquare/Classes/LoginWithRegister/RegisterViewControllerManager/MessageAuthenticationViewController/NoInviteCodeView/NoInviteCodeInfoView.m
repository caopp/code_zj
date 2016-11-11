//
//  NoInviteCodeInfoView.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/6.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "NoInviteCodeInfoView.h"
#import "UIColor+UIColor.h"
@implementation NoInviteCodeInfoView

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.photoLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    self.camera.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];

}



//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder]) {
//        NoInviteCodeInfoView *containerView = [[[UINib nibWithNibName:@"NoInviteCodeInfoView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
//        CGRect newFrame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 106);
//        containerView.frame = newFrame;
//        
//        [self addSubview:containerView];
//    }
//    return self;
//}


- (IBAction)didClickPhotoAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickPhotoAction)]) {
        [self.delegate performSelector:@selector(didClickPhotoAction)];
    }
}

- (IBAction)didClickCameraAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCameraAction)]) {
        [self.delegate performSelector:@selector(didClickCameraAction)];
    }
    
}




@end
