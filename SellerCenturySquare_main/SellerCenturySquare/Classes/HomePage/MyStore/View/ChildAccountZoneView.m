//
//  ChildAccountZoneView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "ChildAccountZoneView.h"
#import "Masonry.h"

@interface ChildAccountZoneView ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end


@implementation ChildAccountZoneView
- (void)awakeFromNib
{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        
        
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@123);
        
    }];
    
    
    
}
- (IBAction)addChildAccountBtn:(id)sender {
    
    [self.delegate childAccountZoneAddChildAccount];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

