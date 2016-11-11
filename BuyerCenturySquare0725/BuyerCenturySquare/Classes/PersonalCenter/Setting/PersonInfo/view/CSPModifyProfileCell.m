//
//  CSPModifyProfileCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 9/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPModifyProfileCell.h"

@implementation CSPModifyProfileCell
@synthesize maleButton = maleButton_;
@synthesize femaleButton = femaleButton_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.maleButton = [[UIButton alloc]init];
        self.femaleButton =[[UIButton alloc]init];
        
        self.maleButton.layer.cornerRadius = 2.0f;
        self.femaleButton.layer.cornerRadius = 2.0f;
        
        [self.maleButton setTitle:@"男" forState:UIControlStateNormal];
        [self.femaleButton setTitle:@"女" forState:UIControlStateNormal];
        
        [self.maleButton setBackgroundColor:[UIColor blackColor]];
        [self.femaleButton setBackgroundColor:HEX_COLOR(0xe2e2e2FF)];
        
        [self.maleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.femaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.maleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.femaleButton.titleLabel.font = [UIFont systemFontOfSize:14];        
        self.maleButton.hidden = YES;
        self.femaleButton.hidden = YES;
        [self addSubview:self.maleButton];
        [self addSubview:self.femaleButton];

    }
    return self;
    
    
}

@end
